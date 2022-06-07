package main

import (
	"context"
	"fmt"
	"strings"

	"crypto/rand"
	"encoding/hex"

	k8slabels "k8s.io/apimachinery/pkg/labels"

	corev1 "k8s.io/api/core/v1"
	v1 "k8s.io/apimachinery/pkg/apis/meta/v1"

	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/gruntwork-io/terratest/modules/testing"

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

var CurlCommand = []string{"curl", "-v", "-m", "5", "-s", "-L"}

func randomHex(n int) (string, error) {
	bytes := make([]byte, n)
	if _, err := rand.Read(bytes); err != nil {
		return "", err
	}
	return hex.EncodeToString(bytes), nil
}

// Check for 'OCI runtime exec failed' error
// TODO: There would hopefully be a better way to check this.
func HasCurl(t testing.TestingT, options *k8s.KubectlOptions, podName string, containerName string) (bool, error) {
	_, err := k8s.ExecE(t, options, podName, containerName, []string{"curl", "--version"})

	if err == nil {
		return true, nil
	}

	if strings.Contains(err.Error(), "OCI runtime exec failed") {
		return false, nil
	} else {
		return false, fmt.Errorf("HasCurl failed with unknown error: %w", err)
	}
}

// Either find an existing pod that has curl, or create one.
// Select a pod by labels, not by name.
func GetOrCreateEndpoint(t testing.TestingT, options *k8s.KubectlOptions, name string, labels map[string]string, customPorts []corev1.ContainerPort) (*corev1.Pod, error) {

	clientset, err := k8s.GetKubernetesClientFromOptionsE(t, options)
	if err != nil {
		return nil, err
	}

	pods, err := clientset.CoreV1().Pods(options.Namespace).List(context.Background(), v1.ListOptions{
		LabelSelector: k8slabels.SelectorFromSet(labels).String(),
	})

	if err != nil {
		return nil, err
	}

	// Pod Exists and has curl
	// Check every container
	for _, pod := range pods.Items {
		for _, container := range pod.Spec.Containers {
			hascurl, err := HasCurl(t, options, pod.Name, container.Name)
			if hascurl && err == nil {
				return &pod, nil
			}
		}
	}

	return CreateEndpoint(t, options, name, labels, customPorts)
}

func main() {
	fmt.Println("Use this module with gotest.")
}
