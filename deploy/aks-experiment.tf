provider "azurerm" {
  version = "=1.5.0"
}

variable "resource_group_name" { type = "string" }
variable "location" { type = "string" }
variable "cluster_name" { type = "string" }
variable "dns_prefix" { type = "string" }
variable "ssh_public_key" { type = "string" }
variable "agent_count" { type = "string" }
variable "client_id" { type = "string" }
variable "client_secret" { type = "string" }

resource "azurerm_resource_group" "k8s" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "${var.cluster_name}"
  location            = "${azurerm_resource_group.k8s.location}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"
  dns_prefix          = "${var.dns_prefix}"

  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = "${file("${var.ssh_public_key}")}"
    }
  }

  agent_pool_profile {
    name            = "default"
    count           = "${var.agent_count}"
    vm_size         = "Standard_D4s_v3"
    os_type         = "Linux"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = "${var.client_id}"
    client_secret = "${var.client_secret}"
  }

  tags {
    Environment = "Production"
  }
}

output "kube_config" {
  value = "${azurerm_kubernetes_cluster.k8s.kube_config_raw}"
}

output "host" {
  value = "${azurerm_kubernetes_cluster.k8s.kube_config.0.host}"
}

provider "kubernetes" {
  host                   = "${azurerm_kubernetes_cluster.k8s.kube_config.0.host}"
  # username               = "${azurerm_kubernetes_cluster.k8s.kube_config.0.username}"
  # password               = "${azurerm_kubernetes_cluster.k8s.kube_config.0.password}"
  client_certificate     = "${base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate)}"
}

resource "kubernetes_persistent_volume_claim" "redis_pvc" {
  metadata {
    name = "terraform-redis-pvc"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests {
        storage = "5Gi"
      }
    }
    storage_class_name = "managed-premium"
  }
}

resource "kubernetes_pod" "test_pod" {
  metadata {
    name = "terraform-test-pod"
    labels {
      app = "MyApp"
    }
  }

  spec {
    container {
      image = "nginx:1.7.9"
      name  = "test-container"
    }
  }
}

resource "kubernetes_service" "test_service" {
  metadata {
    name = "terraform-test-service"
  }
  spec {
    selector {
      app = "${kubernetes_pod.test_pod.metadata.0.labels.app}"
    }
    session_affinity = "ClientIP"
    port {
      port = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_pod" "redis_pod" {
  metadata {
    name = "terraform-redis-pod"
    labels {
      app = "Redis"
    }
  }

  spec {
    container {
      image = "redis:4.0-alpine"
      name  = "redis-container"
    }
    volume {
      name = "redis-volume"
      persistent_volume_claim {
        claim_name = "${kubernetes_persistent_volume_claim.redis_pvc.metadata.0.name}"
      }
    }
  }
}

resource "kubernetes_service" "redis_service" {
  metadata {
    name = "terraform-redis-service"
  }
  spec {
    selector {
      app = "${kubernetes_pod.redis_pod.metadata.0.labels.app}"
    }
    port {
      port = 6379
      target_port = 6379
    }
  }
}

