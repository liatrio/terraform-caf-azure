provider: ${dns_provider}
sources:
- ingress
domainFilters:
${domain_filters}
azure:
  resourceGroup: ${resource_group}
  tenantId: ${tenant_id}
  subscriptionId: ${subscription_id}
  useManagedIdentityExtension: true
  userAssignedIdentityID: ${user_assigned_identity_id}
podLabels:
  aadpodidbinding: ${pod_identity}
txtOwnerId: "default"
serviceAccount:
  name: ${service_account_name}
  create: false
policy: sync
logLevel: debug
