output "github_runners_namespace" {
    value = kubernetes_namespace.runners.metadata.0.name
}
