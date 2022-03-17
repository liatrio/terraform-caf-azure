global:
  leaderElection:
    namespace: ${namespace}
installCRDs: true
serviceAccount:
  name: cert-manager
securityContext:
  enabled: true
  fsGroup: 1001
podLabels:
  aadpodidbinding: ${pod_identity}