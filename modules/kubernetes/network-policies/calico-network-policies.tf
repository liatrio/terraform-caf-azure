locals {
    namespace_list = join(", ", formatlist("\"%s\"", var.excluded_namespaces))
}

# Adapted from https://projectcalico.docs.tigera.io/security/kubernetes-default-deny
#
# Interpret the following as:
# 
# > Unless you're in the excluded namespaces list,
# > you're only allowed to talk to DNS by default,
# > and you cannot accept any connections.
resource "kubernetes_manifest" "global_deny_by_default" {
    count = var.default_deny ? 1 : 0

    manifest = {
        apiVersion = "projectcalico.org/v3"
        kind = "GlobalNetworkPolicy"
        metadata = {
            name = "deny-by-default-unless-system"
        }

        spec = {
            namespaceSelector = "kubernetes.io/metadata.name not in { ${local.namespace_list} }"
            
            types = [
                "Ingress",
                "Egress"
            ]

            egress = [
                {
                    action      = "Allow"
                    protocol    = "UDP"
                    destination = {
                        selector = "k8s-app == \"kube-dns\""
                        ports = [
                            53
                        ]
                    }
                }
            ]
        }
    }
}