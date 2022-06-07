package main

import (
	"log"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/k8s"
	// "github.com/gruntwork-io/terratest/modules/testing"
)

const defaultDenyNamespace = netpolNamespacePrefix + "default-deny"

// Exit codes
// https://everything.curl.dev/usingcurl/returns#available-exit-codes
var CURL_DNS_FAILED int = 6
var CURL_CONNECTION_FAILED int = 7

// Services have DNS == ✅
func testDNS(t *testing.T) {
	t.Parallel()

	kubeSystemOptions := &k8s.KubectlOptions{Namespace: "default"}
	appOptions := &k8s.KubectlOptions{Namespace: defaultDenyNamespace}

	svc := k8s.GetService(t, kubeSystemOptions, "kubernetes")
	svcURL := k8s.GetServiceEndpoint(t, kubeSystemOptions, svc, 80)

	pod, err := GetOrCreateEndpoint(t, appOptions, "netpol-testing-dns", map[string]string{}, nil)
	if err != nil {
		t.Errorf("Failed to get or create pod: %s", err.Error())
	}

	out, _ := k8s.ExecE(t, appOptions, pod.Name, "", append(CurlCommand, svcURL))

	// The command might still fail, but what's important is that DNS worked.
	if strings.Contains(out.Stderr, svc.Spec.ClusterIP) {
		log.Printf("[dns] curl from %s resolved IP of %s", PodName(pod), SvcName(svc))
		return
	}

	// DNS Could not resolve exit code 6.
	if out.ExitCode == 6 {
		t.Errorf("Curl failed to resolve host (exit code: ")
	}
}

// User apps have internet == ❌
func testAppToInternet(t *testing.T) {
	t.Parallel()

	appOptions := &k8s.KubectlOptions{Namespace: defaultDenyNamespace}

	pod, err := GetOrCreateEndpoint(t, appOptions, "netpol-testing-internet-egress", map[string]string{}, nil)
	if err != nil {
		t.Errorf("Failed to get or create pod: %s", err.Error())
	}

	out, err := k8s.ExecE(t, appOptions, pod.Name, "", append(CurlCommand, "google.com"))

	if out.ExitCode == 0 {
		// Bad!
		t.Errorf("[egress] %s to internet succeeded", PodName(pod))
	} else if out.ExitCode == 7 {
		// Good! DNS worked (exit code 6) but connection was blocked.
		log.Printf("[egress] %s failed to reach to internet", PodName(pod))
	} else {
		// ??? Bad!
		t.Errorf("[egress] %s had unknown error: %s", PodName(pod), out.Stderr)
	}
}

// We want the systen to reach the internet by default
// System apps have internet == ✅
func testSystemToInternet(t *testing.T) {
	t.Parallel()

	systemOptions := &k8s.KubectlOptions{Namespace: "kube-system"}

	pod, err := CreateEndpoint(t, systemOptions, "netpol-testing-internet-egress", map[string]string{"netpol-testing": "egress-to-internet"}, nil)
	if err != nil {
		t.Errorf("Failed to get or create pod: %s", err.Error())
	}

	out, err := k8s.ExecE(t, systemOptions, pod.Name, "", append(CurlCommand, "google.com"))

	if out.ExitCode == 0 {
		// Good! We want to connect
		log.Printf("[egress] %s to internet succeeded", PodName(pod))
	} else if out.ExitCode == 7 {
		// Bad!
		t.Errorf("[egress] %s failed to reach to internet", PodName(pod))
	} else {
		// ??? Bad!
		t.Errorf("[egress] %s had unknown error: %s", PodName(pod), out.Stderr)
	}
}

// app to app, same ns == ✅
func testAppToAppSameNS(t *testing.T) {
	t.Parallel()

	appOptions := &k8s.KubectlOptions{Namespace: defaultDenyNamespace}

	podA, err := CreateEndpoint(t, appOptions, "netpol-testing-app-a", map[string]string{"netpol-testing": "app-to-app"}, nil)
	if err != nil {
		t.Errorf("Failed to create pod: %s", err.Error())
	}

	podB, err := CreateEndpoint(t, appOptions, "netpol-testing-app-b", map[string]string{"netpol-testing": "app-to-app"}, nil)
	if err != nil {
		t.Errorf("Failed to create pod: %s", err.Error())
	}

	out, _ := k8s.ExecE(t, appOptions, podA.Name, "", append(CurlCommand, podB.Status.PodIP))

	if out.ExitCode == 0 {
		log.Printf("[app-to-app-same-ns] %s -> %s connected", PodName(podA), PodName(podB))
	} else {
		t.Errorf("[app-to-app-same-ns] failed to connect inside the same ns: %s", out.Stderr)
	}

}

// app to app, across ns == ❌

//
// // app to system == ❌
// func testAppToSystem(t *testing.T) {
//
// }
//
// // system to app == ✅
// func testSystemToApp(t *testing.T) {
//
// }

func TestDefaultDeny(t *testing.T) {

	options := &k8s.KubectlOptions{Namespace: defaultDenyNamespace}

	k8s.CreateNamespace(t, options, options.Namespace)

	t.Cleanup(func() { k8s.DeleteNamespace(t, options, options.Namespace) })

	t.Run("Internet egress forbidden for app namespaces", testAppToInternet)
	t.Run("Internet egress allowed for system namespaces", testSystemToInternet)
	t.Run("DNS works", testDNS)
	// t.Run("App to App within NS allowed", testAppToAppSameNS)
}
