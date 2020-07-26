#######################################################
# Azure Terraform - Infrastructure as a Code (IaC)
#  
# - Azure Kubernetes 
#    - Advance Networking - Azure CNI
# - Azure DataBricks
#
# ----------------------------------------------------
#  Initial Configuration
# ----------------------------------------------------
# - Run this in Azure CLI
#   az login
#   az ad sp create-for-rbac -n "AzureTerraform" --role="Contributor" --scopes="/subscriptions/[SubscriptionID]"
#
# - Then complete the variables in the variables.tf file
#   - subscription_id  
#   - client_id  
#   - client_secret  
#   - tenant_id  
#   - ssh_public_key  
#   - access_key
#
####################################################### 
#----------------------------------------------------
# Azure Terraform Provider
#----------------------------------------------------

provider "azurerm" { 
  features {}
  version = ">=2.0.0"  
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id 
}

data "azurerm_subscription" "primary" {}

#----------------------------------------------------
# Resource Group
#----------------------------------------------------

resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group
  location = var.location
}
 
#----------------------------------------------------
# azurerm_databricks_workspace
#----------------------------------------------------
 resource "azurerm_databricks_workspace" "az-databricks01" {
 name                = "az-databricks01"
 location            = azurerm_resource_group.resource_group.location
 resource_group_name = azurerm_resource_group.resource_group.name
 sku                 = "premium" # standard
}

#----------------------------------------------------
# Virtual Networks
#----------------------------------------------------

resource "azurerm_virtual_network" "az-vnet01" {
  name                = "az-vnet01"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  address_space       = [var.virtual_network_address_prefix]
 
  tags = {
    Environment = var.environment
  }
}

resource "azurerm_subnet" "az-k8s-subnet" {
  name                 = "az-k8s-subnet" 
  virtual_network_name = azurerm_virtual_network.az-vnet01.name
  resource_group_name  = azurerm_resource_group.resource_group.name
  address_prefixes     = [var.aks_subnet_address_prefix]
}

resource "azurerm_subnet" "az-apgw-subnet" {
  name                 = "az-apgw-subnet"
  virtual_network_name = azurerm_virtual_network.az-vnet01.name
  resource_group_name  = azurerm_resource_group.resource_group.name
  address_prefixes     = [var.app_gateway_subnet_address_prefix]
}


#----------------------------------------------------
# Public Ip (Port 80)
#---------------------------------------------------- 

resource "azurerm_public_ip" "az-pip01" {
  name                = "az-pip01"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Environment = var.environment
  }
}
 
#----------------------------------------------------
# Public Ip (Port 443)
#---------------------------------------------------- 

resource "azurerm_public_ip" "az-pip02" {
  name                = "az-pip02"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Environment = var.environment
  }
}
  
#----------------------------------------------------
# azurerm_log_analytics_workspace , 
# You can enable this if you like
#----------------------------------------------------
   
#resource "azurerm_log_analytics_workspace" "azloganalytics01" {
#  name                = "azloganalytics01"
#  location            = azurerm_resource_group.resource_group.location
#  resource_group_name = azurerm_resource_group.resource_group.name
#  sku                 = "Standard"
#}
 
#resource "azurerm_log_analytics_solution" "azakslogsolution01" {
#    solution_name         = "ContainerInsights"
#    location              = azurerm_resource_group.resource_group.location
#    resource_group_name   = azurerm_resource_group.resource_group.name
#
#    workspace_resource_id = azurerm_log_analytics_workspace.azloganalytics01.id
#    workspace_name        = azurerm_log_analytics_workspace.azloganalytics01.name
#
#    plan {
#        publisher = "Microsoft"
#        product   = "OMSGallery/ContainerInsights"
#    }
#	
#	depends_on = [
#    azurerm_log_analytics_workspace.azloganalytics01 
#  ]
#}


#----------------------------------------------------
# azurerm_kubernetes_cluster
#----------------------------------------------------
  
resource "azurerm_kubernetes_cluster" "az-k8s" {
  name                = "az-k8s"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  dns_prefix          = var.dns_prefix

  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }
  
  addon_profile {
    http_application_routing {
      enabled = false
    }
#	oms_agent {
#        enabled                    = true
#        log_analytics_workspace_id = azurerm_log_analytics_workspace.azloganalytics01.id
#        }
  }
  
  default_node_pool {
    name                 = "agentpool"
    node_count           = var.node_count
	max_pods             = var.max_pods
    vm_size              = var.vm_size
    os_disk_size_gb      = var.aks_agent_os_disk_size
    vnet_subnet_id       = azurerm_subnet.az-k8s-subnet.id
		
    enable_auto_scaling  = var.autoscale
    #node_count          = var.autoscale_node_count
    max_count            = var.autoscale_max_count 
    min_count            = var.autoscale_min_count
  }
 
  
  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }
   
  
  network_profile {
    network_plugin     = "azure"
    dns_service_ip     = var.aks_dns_service_ip
    docker_bridge_cidr = var.aks_docker_bridge_cidr
    service_cidr       = var.aks_service_cidr
  } 
  
  depends_on = [
    azurerm_virtual_network.az-vnet01   #,  
#	azurerm_log_analytics_solution.azakslogsolution01 
  ]
}
