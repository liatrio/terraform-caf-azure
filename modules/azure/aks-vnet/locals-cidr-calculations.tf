locals {
  # Takes in a /16 virtual network cidr range
  # Assigns the first half of give cidr range to the pods and nodes subnet
  # Assigns the next quarter to the services subnet
  # Assigns the second host available within the services subnet to the kube-dns discovery service
  aks_pods_nodes_subnet = cidrsubnet(var.vnet_address_range, 1, 0)
  aks_services_subnet   = cidrsubnet(var.vnet_address_range, 2, 2)
  aks_dns_service_host  = cidrhost(cidrsubnet(var.vnet_address_range, 2, 2), 2)
<<<<<<< Updated upstream
=======
  ingress_host_ip       = cidrhost(cidrsubnet(var.vnet_address_range, 2, 2), 3)
>>>>>>> Stashed changes
}
