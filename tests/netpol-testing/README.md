# TODO:

- Things to fix! Jobs are not cleaned up at the moment
- We should also migrate this to terratest

# Verify your network policies with `go test -v`

**Compatibility: This should work with kubernetes >= 1.21**

Inspired by the approach in [mattfenwick/cyclonus](https://github.com/mattfenwick/cyclonus).

Define your **desired** network behaviour using `*_test.go` files. 
The tests are up to the author, but we provide some tools:

- Create a namespace with labels, 
- Given a label selector and a namespace:
  + Try to find an existing pod and use curl from it
  + If that fails, deploy `agnhost` with those pod labels and advertised ports of your choice.
  + Run `/agnhost connect` instead of curl (supports more options).
- Run your tests concurrently
- Automatically clean up temporary pods, delete the temporary namespaces easily.

## Warnings

- We are using Pods (via a Job), but once we hit k8s 1.24 we can switch this to emphemeral containers. 
- Emphemeral containers will be a better way to do this debugging.
- The spawned pods use a pod-deletion-cost annotation to supercede your regular pods. So this might break your apps while testing.

**Don't run these tests on prod. This implementation deploys dummy pods, which may inadvertently be load-balanced by your services. E.g. you might accidentally send a user or a system to a dummy service for a moment if you use this. It might also delete one of your pods in each replicaset.**

## How to add a module

Every test is in the same `main` package. We organize the higher-level feature (e.g. "A default-deny policy") into a file and then a **single** test, containing *subtests**. E.g.

```go
func TestDefaultDeny(t *testing.T) {
	CreateNamespace(defaultDenyNamespace, map[string]string{})
	defer DeleteNamespace(defaultDenyNamespace)

	t.Run("Internet forbidden", testInternet)
	t.Run("DNS works", testDNS)
}
```

The subtests may then, for example, `exec` into a fresh `agnhost` pod, and validate what they can/can't do.

A more elaborate test might also validate, e.g. that your `Ingress` is able to route to the service from the ingress gateway. You could either `curl` from inside of an ingress-controller pod to an existing service, or if you want to see if the ingress is publicly routable, you could create an Ingress object, make a request from the go-client to that URL, and then delete the ingress object.


# Policies

## Default Deny

The aim of the default deny policy is to ensure that **every single pod** is covered by a default policy. We have one partitioning of the namespaces: `system` namespaces, and non-system namespaces. The system namespaces includes, for example, `toolchain`, `kube-system`, `gatekeeper-system`, etc. Non-system namespaces are everything else.

Desired policy is:

- Everything has DNS (port 53 to kube-system's CoreDNS)
- System namespaces can egress to anything.
- System namespaces can accept ingress from pods in the system namespace.
- Non-System namespaces cannot egress outside of their own namespace

