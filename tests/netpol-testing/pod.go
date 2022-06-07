// Create an "Endpoint" for sending/recieving curl calls
// We use a Job to manage the Pod lifecycle and ensure that the pod gets cleaned up.
// The Job itself should get pruned by kube-janitor (assumes kube-janitor is running)
// You can also choose to clean up the Job manually.
package main

import (
	"context"
	"errors"
	"fmt"
	"time"

	batchv1 "k8s.io/api/batch/v1"
	corev1 "k8s.io/api/core/v1"
	"k8s.io/client-go/kubernetes"

	v1 "k8s.io/apimachinery/pkg/apis/meta/v1"

	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/gruntwork-io/terratest/modules/testing"
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

// Given a job, find an owned pod.
// This assumes there's only one, because it's specific to our use-case.
func getOwnedPod(client *kubernetes.Clientset, job *batchv1.Job, retries int, sleep time.Duration) (*corev1.Pod, error) {

	namespace := job.ObjectMeta.Namespace
	jobID := job.ObjectMeta.UID

	for i := 0; i < retries; i++ {
		pods, err := client.CoreV1().Pods(namespace).List(context.Background(), v1.ListOptions{})
		if err != nil {
			continue
		}

		// Return once pod exists and is running
		if len(pods.Items) > 0 {
			for _, pod := range pods.Items {
				for _, ownerRef := range pod.ObjectMeta.OwnerReferences {
					if ownerRef.UID == jobID {
						return &pod, nil
					}
				}
			}
		}
		time.Sleep(sleep)
	}

	return nil, errors.New(fmt.Sprintf("Didn't find a pod owned by Job: %s", jobID))
}

// Create a Job (with short TTL) running agnhost
// Configure this job to expose the necessary ports, and pass
// the pod the correct labels to be targeted by network policy
//
// The http & https ports are always included, others need to
// be stated explicitly using the customPorts argument.
func CreateEndpoint(t testing.TestingT, options *k8s.KubectlOptions, name string, labels map[string]string, customPorts []corev1.ContainerPort) (*corev1.Pod, error) {

	clientset, err := k8s.GetKubernetesClientFromOptionsE(t, options)
	if err != nil {
		return nil, err
	}

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
			Namespace: options.Namespace,
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
						"janitor/ttl": "6h",
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
	job, err = clientset.BatchV1().Jobs(options.Namespace).Create(context.Background(), job, v1.CreateOptions{})
	if err != nil {
		return nil, err
	}

	// 30 seconds should be *way* more than enough time for the pod to get submitted.
	// It doesn't have to be running yet, just needs to exist in any state.
	pod, err := getOwnedPod(clientset, job, 6, 5*time.Second)
	err = k8s.WaitUntilPodAvailableE(t, options, pod.Name, 6, 5*time.Second)
	return pod, err
}
