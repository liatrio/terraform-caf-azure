# Network Policy

Kubernetes offers [Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/) for Layer 3/4 network traffic control. However, while Network Policies are part of the kubernetes spec, you need install an implementation of a network policy controller in order to actually enforce the policies. The network policy controller needs to integrate with your Container-Networking-Interface (CNI) in order to function[^1]. Some Kubernetes offerings include Network Policy by default, for example [GKE uses Cilium](https://cloud.google.com/blog/products/containers-kubernetes/bringing-ebpf-and-cilium-to-google-kubernetes-engine) as do Digital Ocean and others.

[^1]: Many tools, Calico and Cilium included, also have a CNI, but the network policy controller is separate and they often support many CNIs. [For example](https://projectcalico.docs.tigera.io/reference/installation/api#operator.tigera.io/v1.CNISpec), Calico supports Calico-CNI, Azure-VNET, GKE CNI, and Amazon-VPC CNI.

On Azure there are (at the time of writing) two options[^1]: Calico and Azure-NPM. Calico is a well known and well tested Network Policy implementation that *works* and also support Global Network Policies (as opposed to the default, which are namespaced NetworkPolicy objects).

[^2]: [AKS Network Policy Options](https://docs.microsoft.com/en-us/azure/aks/use-network-policies#network-policy-options-in-aks)

Without Network Policies, your pods are wide-open to all other pods, and depending on your cloud networking config, [they may be exposed beyond the cluster](https://raesene.github.io/blog/2021/01/03/Kubernetes-is-a-router/). It is therefore a recommendation in most kubernetes-hardening guidance, including [the NSA Kubernetes hardening guide](https://media.defense.gov/2021/Aug/03/2002820425/-1/-1/0/CTR_Kubernetes_Hardening_Guidance_1.1_20220315.PDF#page=23) to ensure that you have network policies enabled and applied.

### Default Deny

As mentioned, pods have unrestricted networking unless network policies are enabled and in-place. But, having network policies turned on isn't enough, your pod has to be explicitly selected (by a pod label) by a network policy for there to be any restriction.

As a result, it's very easy to miss restricting pods, because network policy is essentially "opt-in". To remediate this, a common recommendation is to enable a [global default deny policy](https://projectcalico.docs.tigera.io/security/kubernetes-default-deny#enable-default-deny-calico-global-network-policy-non-namespaced)[^3]. Since this is a common approach, we include here a flag to enable this by default -- the policy itself is [here](https://github.com/liatrio/terraform-caf-azure/blob/72bd1da366ef5984bd290084b1c172d8eff590ec/modules/kubernetes/network-policies/calico-network-policies.tf#L5-L52).

[^3]: Recall that global network policies are **not** part of the Kubernetes spec, but they are so common that Calico and Cilium implement them. If you don't have access to a global network policy Custom Resource, you would probably need to use a namespace controller to create network policies automatically.
