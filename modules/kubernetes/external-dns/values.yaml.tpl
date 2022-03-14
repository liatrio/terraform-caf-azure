provider: ${dns_provider}
sources:
- ingress
%{~ if watch_services == true }
- service
%{~ endif }
domainFilters:
${domain_filters}
%{~ if length(exclude_domains) > 0 ~}
excludeDomains:
%{ for domain in exclude_domains ~}
- ${domain}
%{~ endfor }
%{~ endif ~}
azure:
  resourceGroup: ${resource_group}
  tenantId: ${tenant_id}
  subscriptionId: ${subscription_id}
  useManagedIdentityExtension: ${use_managed_identity_extension}
  userAssignedIdentityID: ${user_assigned_identity_id}
podLabels:
  aadpodidbinding: ${pod_identity}
