locals {
  # Takes in a /16 virtual network cidr range
  # Assigns the first half (/17) of given cidr range to the pods and nodes subnet
  # Assigns the next quarter to the services subnet (todo: this should be a standard range for all clusters)
  # Assigns the second host available within the services subnet to the kube-dns discovery service
  # Assigns the next /21 for Azure private service endpoints
  subnets                  = cidrsubnets(var.vnet_address_range, 1, 2, 5)
  aks_pods_nodes_subnet    = local.subnets[0]
  aks_services_subnet      = local.subnets[1]
  aks_dns_service_host     = cidrhost(cidrsubnet(var.vnet_address_range, 2, 2), 2)
  service_endpoints_subnet = local.subnets[2]
}
