controller:
  publishService:
    enabled: true
  service:
    type: LoadBalancer
    %{ if internal == true }
    annotations:
      service.beta.kubernetes.io/azure-load-balancer-internal: "true"   
    %{ endif } 
  %{if length(extra_args) > 0}
  extraArgs:
    ${indent(4, yamlencode(extra_args))}
  %{~endif~}
  ingressClass: ${ingress_class}
  autoscaling:
    enabled: true
    targetCPUUtilizationPercentage: 70
    targetMemoryUtilizationPercentage: 85
    minReplicas: 2
  livenessProbe:
    timeoutSeconds: 10
  readinessProbe:
    timeoutSeconds: 10
  scope:
    enabled: false
  resources:
    requests:
      cpu: 300m
      memory: 256Mi
    limits:
      cpu: 750m
      memory: 512Mi
defaultBackend:
  resources:
    requests:
      cpu: 1m
      memory: 4Mi
    limits:
      cpu: 1m
      memory: 16Mi
