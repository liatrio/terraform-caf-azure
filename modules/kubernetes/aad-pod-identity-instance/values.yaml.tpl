azureIdentity:
  name: "${identity_name}"
  behavior: namespaced
  type: 0
  resourceID: "${identity_resource_id}"
  clientID: "${identity_client_id}"
  
azureIdentityBinding:
  name: "${identity_name}-binding"
  selector: "${identity_name}"
