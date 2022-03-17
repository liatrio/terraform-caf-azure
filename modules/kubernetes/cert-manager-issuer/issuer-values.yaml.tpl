issuerName: ${issuer_name}
issuerKind: ClusterIssuer
acme:
  enabled: true
  server: ${issuer_server}
  email: ${issuer_email}
  privateKeySecretRef:
    name: letsencrypt
  dnsProvider:
    type: azureDNS
  solver: dns
azure:
  subscriptionID: ${subscription_id}
  resourceGroup: ${resource_group}
  zoneName: ${dns_zone_name}
