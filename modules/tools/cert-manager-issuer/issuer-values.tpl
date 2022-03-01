apiVersion: cert-manager.io/v1
kind: ${issuer_kind}
metadata:
  name: ${issuer_name}
spec:
  acme:
    enabled: ${ issuer_type == "acme" }
    server: ${ issuer_server }
    email: ${ issuer_email }
    privateKeySecretRef:
      name: letsencrypt
    solvers:
    - dns01:
        azureDNS:
          subscriptionID: ${ azure_subscription_id }
          resourceGroupName: ${ azure_resource_group_name }
          hostedZoneName: ${ dns_zone_name }
          environment: AzurePublicCloud
          managedIdentity:
            clientID: ${ azure_managed_identity_client_id }
    dnsProvider:
      type: ${provider_dns_type}
    solver: ${acme_solver}
  ca:
    enabled: ${issuer_type == "ca"}
    secret: ${ca_secret}
  selfSigned:
    enabled: ${ issuer_type == "selfSigned" }
