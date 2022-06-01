package main

import (
	"context"
	"log"
	"strings"
	"testing"

	v1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

const defaultDenyNamespace = netpolNamespacePrefix + "default-deny"

// Services have DNS == ✅
func testDNS(t *testing.T) {
	t.Parallel()

	svc, err := Client.CoreV1().Services("default").Get(context.Background(), "kubernetes", v1.GetOptions{})
	if err != nil {
		t.Errorf("Failed to get kubernetes svc in the default namespace")
	}

	pod, err := GetOrCreateEndpoint(defaultDenyNamespace, "netpol-testing-dns", map[string]string{}, nil)
	if err != nil {
		t.Errorf("Failed to get or create pod: %s", err.Error())
	}

	_, stderr, callerr := ExecCommand(pod, append(CurlCommand, "kubernetes.default"), "")

	if strings.Contains(stderr, svc.Spec.ClusterIP) {
		log.Printf("[dns] curl from %s resolved IP of %s", PodName(pod), SvcName(svc))
		return
	}

	// DNS Could not resolve exit code 6.
	// https://everything.curl.dev/usingcurl/returns#available-exit-codes
	if strings.Contains(callerr, "command terminated with exit code 6") {
		t.Errorf("Curl failed to resolve host")
	}
}

// User apps have internet == ❌
func testAppToInternet(t *testing.T) {
	t.Parallel()

	pod, err := GetOrCreateEndpoint(defaultDenyNamespace, "netpol-testing-internet-egress", map[string]string{}, nil)
	if err != nil {
		t.Errorf("Failed to get or create pod: %s", err.Error())
	}

	_, _, callerr := ExecCommand(pod, append(CurlCommand, "google.com"), "")

	hasInternet := (callerr == "")

	if hasInternet {
		// Bad!
		t.Errorf("[egress] %s to internet succeeded", PodName(pod))
	} else {
		// Good!
		log.Printf("[egress] %s failed to reach to internet", PodName(pod))
	}
}

// We want the systen to reach the internet by default
// System apps have internet == ✅
func testSystemToInternet(t *testing.T) {
	t.Parallel()

	pod, err := CreateEndpoint("kube-system", "netpol-testing-internet-egress", map[string]string{"netpol-testing": "egress-to-internet"}, nil)
	if err != nil {
		t.Errorf("Failed to get or create pod: %s", err.Error())
	}

	_, _, callerr := ExecCommand(pod, append(CurlCommand, "google.com"), "")

	hasInternet := (callerr == "")

	if hasInternet {
		// Good!
		log.Printf("[egress] %s failed to reach to internet", PodName(pod))
	} else {
		// Bad!
		t.Errorf("[egress] %s to internet succeeded", PodName(pod))
	}
}

// app to app, same ns == ✅
func testAppToAppSameNS(t *testing.T) {
	t.Parallel()

	podA, err := CreateEndpoint(defaultDenyNamespace, "netpol-testing-app-a", map[string]string{"netpol-testing": "app-to-app"}, nil)
	if err != nil {
		t.Errorf("Failed to create pod: %s", err.Error())
	}

	podB, err := CreateEndpoint(defaultDenyNamespace, "netpol-testing-app-b", map[string]string{"netpol-testing": "app-to-app"}, nil)
	if err != nil {
		t.Errorf("Failed to create pod: %s", err.Error())
	}

	_, stderr, callerr := ExecCommand(podA, append(CurlCommand, podB.Status.PodIP), "")

	appToApp := (callerr == "")

	if appToApp {
		log.Printf("[app-to-app-same-ns] %s -> %s connected", PodName(podA), PodName(podB))
	} else {
		t.Errorf("[app-to-app-same-ns] failed to connect inside the same ns: %s", stderr)
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
	err := CreateNamespace(defaultDenyNamespace, map[string]string{})
	if err != nil {
		t.Errorf("Failed to create testing namespace: %s", err.Error())
	}
	t.Cleanup(func() { DeleteNamespace(defaultDenyNamespace) })

	t.Run("Internet egress forbidden for app namespaces", testAppToInternet)
	t.Run("Internet egress allowed for system namespaces", testSystemToInternet)
	t.Run("DNS works", testDNS)
	// t.Run("App to App within NS allowed", testAppToAppSameNS)
}
