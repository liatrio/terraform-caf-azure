package main

import (
	"bytes"
	"context"
	"errors"
	"flag"
	"fmt"
	"log"
	"strings"
	"time"

	"crypto/rand"
	"encoding/hex"
	"path/filepath"
	"sync"

	k8slabels "k8s.io/apimachinery/pkg/labels"

	batchv1 "k8s.io/api/batch/v1"
	corev1 "k8s.io/api/core/v1"
	v1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/kubernetes/scheme"
	"k8s.io/client-go/rest"
	"k8s.io/client-go/tools/clientcmd"
	"k8s.io/client-go/tools/remotecommand"
	"k8s.io/client-go/util/homedir"

	//
	// Uncomment to load all auth plugins
	_ "k8s.io/client-go/plugin/pkg/client/auth"
	//
	// Or uncomment to load specific auth plugins
	// _ "k8s.io/client-go/plugin/pkg/client/auth/azure"
	// _ "k8s.io/client-go/plugin/pkg/client/auth/gcp"
	// _ "k8s.io/client-go/plugin/pkg/client/auth/oidc"
	// _ "k8s.io/client-go/plugin/pkg/client/auth/openstack"
)

// The agnhost image lets us test TCP, UDP, DNS connectivity
// https://pkg.go.dev/k8s.io/kubernetes/test/images/agnhost#section-readme
// See https://github.com/kubernetes/kubernetes/tree/b2c5bd2a278288b5ef19e25bf7413ecb872577a4/test/images/agnhost#image
const agnhost = "k8s.gcr.io/e2e-test-images/agnhost:2.35"

// Namespace our namespaces, ya know?
const netpolNamespacePrefix = "netpol-testing-"

// If we deploy a pod with labels selected by a replicaset
// instead of deleting OUR pod, make the replicaset delete one of the actual pods.
// This is very intrusive, but it's the only way.
// We mitigate this by checking if the existing pods have `curl`, first.
// If they do, we don't create any new pod in the first place.
// https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/#pod-deletion-cost
const podDeletionCost = "10"

// Job ttl for the agnhost image/job
// the ttl ensures pod cleanup, using
//   activeDeadlineSeconds and ttlSecondsAfterFinished
// https://kubernetes.io/docs/concepts/workloads/controllers/job/#job-termination-and-cleanup
// https://kubernetes.io/docs/concepts/workloads/controllers/job/#ttl-mechanism-for-finished-jobs
const jobTTL = 120

/*
	We use one shared client across the tests,
	we call setup.Do(GetClient) at the beginning of functions
	to make sure we've instantiated it.
*/
var Client *kubernetes.Clientset
var clientConfig *rest.Config
var setup sync.Once

var CurlCommand = []string{"curl", "-v", "-m", "5", "-s", "-L"}

func GetClient() {
	var kubeconfig *string
	if home := homedir.HomeDir(); home != "" {
		kubeconfig = flag.String("kubeconfig", filepath.Join(home, ".kube", "config"), "(optional) absolute path to the kubeconfig file")
	} else {
		kubeconfig = flag.String("kubeconfig", "", "absolute path to the kubeconfig file")
	}
	flag.Parse()

	// use the current context in kubeconfig
	config, err := clientcmd.BuildConfigFromFlags("", *kubeconfig)
	if err != nil {
		panic(err.Error())
	}

	// create the clientset
	clientset, err := kubernetes.NewForConfig(config)
	if err != nil {
		panic(err.Error())
	}

	// Set a global variable
	Client = clientset
	clientConfig = config

	_, err = Client.CoreV1().Namespaces().List(context.Background(), v1.ListOptions{})
	if err != nil {
		log.Fatalf("Could not initialize client: %s", err.Error())
	}
}

func CreateNamespace(namespace string, labels map[string]string) error {
	setup.Do(GetClient)
	ns := corev1.Namespace{
		ObjectMeta: v1.ObjectMeta{
			Name:   namespace,
			Labels: labels,
		},
	}

	_, err := Client.CoreV1().Namespaces().Create(context.Background(), &ns, v1.CreateOptions{})
	return err
}

func DeleteNamespace(namespace string) error {
	setup.Do(GetClient)
	return Client.CoreV1().Namespaces().Delete(
		context.Background(),
		namespace,
		*v1.NewDeleteOptions(5),
	)
}

func randomHex(n int) (string, error) {
	bytes := make([]byte, n)
	if _, err := rand.Read(bytes); err != nil {
		return "", err
	}
	return hex.EncodeToString(bytes), nil
}

// Create a Job (with short TTL) running agnhost
// Configure this job to expose the necessary ports, and pass
// the pod the correct labels to be targeted by network policy
//
// The http & https ports are always included, others need to
// be stated explicitly using the customPorts argument.
func CreateEndpoint(namespace string, name string, labels map[string]string, customPorts []corev1.ContainerPort) (*corev1.Pod, error) {
	setup.Do(GetClient)

	deadline := int64(jobTTL)
	garbageCollection := int32(jobTTL) * 2

	// Include the http & https ports by default,
	// other ports like elasticsearch, postgres, etc
	// will be considered custom.
	ports := []corev1.ContainerPort{
		{
			Name:          "http",
			ContainerPort: 80,
		},
		{
			Name:          "https",
			ContainerPort: 443,
		},
	}

	// Initialize if nil
	if customPorts == nil {
		customPorts = []corev1.ContainerPort{}
	}

	// Custom ports have higher priority than default ports.
	// Merge the two arrays on the `Name` field, preference for
	// the custom ports
	for _, defaultport := range ports {
		exists := false
		for _, port := range customPorts {
			if port.Name == defaultport.Name {
				exists = true
			}
		}
		if !exists {
			customPorts = append(customPorts, defaultport)
		}
	}

	randomSuffix, _ := randomHex(6)
	jobName := name + "-" + randomSuffix
	job := &batchv1.Job{
		ObjectMeta: v1.ObjectMeta{
			Name:      jobName,
			Namespace: namespace,
			Labels:    labels,
		},
		Spec: batchv1.JobSpec{
			ActiveDeadlineSeconds:   &deadline,
			TTLSecondsAfterFinished: &garbageCollection,
			Template: corev1.PodTemplateSpec{
				ObjectMeta: v1.ObjectMeta{
					Labels: labels,
					Annotations: map[string]string{
						"controller.kubernetes.io/pod-deletion-cost": podDeletionCost,
					},
				},
				Spec: corev1.PodSpec{
					Containers: []corev1.Container{
						{
							Name:  "agnhost",
							Image: agnhost,
							Ports: customPorts,
						},
					},
					RestartPolicy: corev1.RestartPolicyNever,
				},
			},
		},
	}

	_, err := Client.BatchV1().Jobs(namespace).Create(context.Background(), job, v1.CreateOptions{})
	if err != nil {
		return nil, err
	}

	// Wait up to 60 seconds for the pod to be created and ready
	//
	// TODO: We could probably make this more concurrent
	// but lets keep it simple for now.
	label, _ := k8slabels.Parse(fmt.Sprintf("job-name=%s", jobName))
	for i := 0; i < 60; i = i + 5 {
		time.Sleep(5 * time.Second)
		pods, err := Client.CoreV1().Pods(namespace).List(context.Background(), v1.ListOptions{
			LabelSelector: label.String(),
		})
		if err != nil {
			continue
		}

		// Return once pod exists and is running
		if len(pods.Items) > 0 {
			pod := &pods.Items[0]
			if pod.Status.Phase == corev1.PodRunning {
				return pod, nil
			}
		}
	}

	return nil, errors.New("NO POD FOUND IN 60 SECONDS")
}

// Execute a command in the pod, returns (stdout, stderr)
func ExecCommand(pod *corev1.Pod, command []string, containerName string) (string, string, string) {

	setup.Do(GetClient)

	req := Client.CoreV1().RESTClient().Post().Resource("pods").Name(pod.Name).Namespace(pod.ObjectMeta.Namespace).SubResource("exec")
	if containerName != "" {
		// optionally specify the container.
		req = req.Param("container", containerName)
	}

	req.VersionedParams(&corev1.PodExecOptions{
		Stdin:     false,
		Stdout:    true,
		Stderr:    true,
		TTY:       false,
		Container: containerName,
		Command:   command,
	}, scheme.ParameterCodec)

	exec, err := remotecommand.NewSPDYExecutor(clientConfig, "POST", req.URL())
	if err != nil {
		panic(err.Error())
	}

	var stdout, stderr bytes.Buffer
	err = exec.Stream(remotecommand.StreamOptions{
		Stdin:  nil,
		Stdout: &stdout,
		Stderr: &stderr,
		Tty:    false,
	})
	if err != nil {
		return stdout.String(), stderr.String(), err.Error()
	}

	return stdout.String(), stderr.String(), ""
}

// Returns a bool for the presense of curl, or an error if
// something unexpected occurred.
func HasCurl(pod *corev1.Pod, containerName string) (bool, error) {
	_, _, callerr := ExecCommand(
		pod,
		[]string{
			"curl",
			"--version",
		},
		containerName,
	)

	if strings.Contains(callerr, "OCI runtime exec failed") {
		return false, nil
	} else if callerr == "" {
		return true, nil
	} else {
		return false, errors.New("CURL EXISTS BUT HAS AN ERROR?")
	}
}

// Either find an existing pod that has curl, or create one.
// Select a pod by labels, not by name.
func GetOrCreateEndpoint(namespace string, name string, labels map[string]string, customPorts []corev1.ContainerPort) (*corev1.Pod, error) {
	setup.Do(GetClient)

	pods, err := Client.CoreV1().Pods(namespace).List(context.Background(), v1.ListOptions{
		LabelSelector: k8slabels.SelectorFromSet(labels).String(),
	})

	if err != nil {
		return nil, err
	}

	// Pod Exists and has curl
	if len(pods.Items) > 0 {
		pod := &pods.Items[0]
		hascurl, err := HasCurl(pod, "")
		if err == nil && hascurl {
			return &pods.Items[0], nil
		}
	}

	return CreateEndpoint(namespace, name, labels, customPorts)
}

func main() {
	// DeleteNamespace("swag")
	setup.Do(GetClient)
	pod, err := CreateEndpoint("swag", "swag", map[string]string{}, nil)
	if err != nil {
		fmt.Println(err.Error())
	}

	hascurl, err := HasCurl(pod, "")
	if err != nil {
		panic(err.Error())
	}
	fmt.Printf("Pod %s has curl: %t\n", pod.Name, hascurl)

	stdout, stderr, callerr := ExecCommand(
		pod,
		[]string{
			"curl",
			"-v",
			"-m",
			"5",
			"google.com",
		},
		"",
	)
	fmt.Printf("stdout: %s\n\nstderr: %s\n\nerr: %s\n", stdout, stderr, callerr)
}
