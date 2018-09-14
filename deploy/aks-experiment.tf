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
variable "principal_id" { type = "string" }

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

resource "azurerm_container_registry" "data2paperACRlive" {
  name                = "data2paperACRlive"
  resource_group_name = "${azurerm_resource_group.k8s.name}"
  location            = "${azurerm_resource_group.k8s.location}"
  admin_enabled       = true
  sku                 = "Basic"
}

resource "azurerm_role_assignment" "acr_read" {
  scope                = "${azurerm_container_registry.data2paperACRlive.id}"
  role_definition_name = "Reader"
  principal_id         = "${var.principal_id}"
  depends_on           = ["azurerm_kubernetes_cluster.k8s"]
  # build and push here TODO
}

output "kube_config" {
  value = "${azurerm_kubernetes_cluster.k8s.kube_config_raw}"
}

output "host" {
  value = "${azurerm_kubernetes_cluster.k8s.kube_config.0.host}"
}

output "acr_info" {
  value = "docker login \"${azurerm_container_registry.data2paperACRlive.login_server}\" -u \"${azurerm_container_registry.data2paperACRlive.admin_username}\" -p \"${azurerm_container_registry.data2paperACRlive.admin_password}\""
}

provider "kubernetes" {
  host                   = "${azurerm_kubernetes_cluster.k8s.kube_config.0.host}"
  # username               = "${azurerm_kubernetes_cluster.k8s.kube_config.0.username}"
  # password               = "${azurerm_kubernetes_cluster.k8s.kube_config.0.password}"
  client_certificate     = "${base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate)}"
}

variable "POSTGRES_HOST" { type = "string" }
variable "POSTGRES_USER" { type = "string" }
variable "POSTGRES_PASSWORD" { type = "string" }
variable "POSTGRES_D2P_USER" { type = "string" }
variable "POSTGRES_D2P_PASSWORD" { type = "string" }
variable "DATA2PAPER_PASSWORD" { type = "string" }
variable "FEDORA_COMMONS_PASSWORD" { type = "string" }
variable "SECRET_KEY_BASE" { type = "string" }
variable "HOST" { type = "string" }
variable "JAVA_OPTS" { type = "string" }
variable "SOLR_DEVELOPMENT_URL" { type = "string" }
variable "SOLR_TEST_URL" { type = "string" }
variable "SOLR_PRODUCTION_URL" { type = "string" }
variable "FEDORA_DEVELOPMENT_URL" { type = "string" }
variable "FEDORA_DEVELOPMENT_PATH" { type = "string" }
variable "FEDORA_TEST_URL" { type = "string" }
variable "FEDORA_TEST_PATH" { type = "string" }
variable "FEDORA_PRODUCTION_URL" { type = "string" }
variable "FEDORA_PRODUCTION_PATH" { type = "string" }
variable "REDIS_DEVELOPMENT_HOST" { type = "string" }
variable "REDIS_DEVELOPMENT_PORT" { type = "string" }
variable "REDIS_TEST_HOST" { type = "string" }
variable "REDIS_TEST_PORT" { type = "string" }
variable "REDIS_PRODUCTION_HOST" { type = "string" }
variable "REDIS_PRODUCTION_PORT" { type = "string" }


resource "kubernetes_persistent_volume_claim" "redis_pvc" {
  metadata {
    name = "redis-pvc"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests {
        storage = "3Gi"
      }
    }
    storage_class_name = "managed-premium"
  }
}

resource "kubernetes_persistent_volume_claim" "fedora_pvc" {
  metadata {
    name = "fedora-pvc"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests {
        storage = "50Gi"
      }
    }
    storage_class_name = "managed-premium"
  }
}

resource "kubernetes_persistent_volume_claim" "solr_pvc" {
  metadata {
    name = "solr-pvc"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests {
        storage = "10Gi"
      }
    }
    storage_class_name = "managed-premium"
  }
}

resource "kubernetes_persistent_volume_claim" "postgres_pvc" {
  metadata {
    name = "postgres-pvc"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests {
        storage = "10Gi"
      }
    }
    storage_class_name = "managed-premium"
  }
}

resource "kubernetes_persistent_volume_claim" "d2p_derivatives_pvc" {
  metadata {
    name = "d2p-derivatives-pvc"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests {
        storage = "10Gi"
      }
    }
    storage_class_name = "managed-premium"
  }
}

resource "kubernetes_persistent_volume_claim" "d2p_uploads_pvc" {
  metadata {
    name = "d2p-uploads-pvc"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests {
        storage = "10Gi"
      }
    }
    storage_class_name = "managed-premium"
  }
}

resource "kubernetes_pod" "nginx_pod" {
  depends_on = ["azurerm_role_assignment.acr_read"]
  metadata {
    name = "nginx-pod"
    labels {
      app = "data2paper"
    }
  }

  spec {
    container {
      image = "nginx:1.7.9"
      name  = "nginx-container"
    }
  }
}

resource "kubernetes_service" "nginx_service" {
  metadata {
    name = "nginx-service"
  }
  spec {
    selector {
      app = "${kubernetes_pod.nginx_pod.metadata.0.labels.app}"
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
  depends_on = ["azurerm_role_assignment.acr_read"]
  metadata {
    name = "redis-pod"
    labels {
      app = "Redis"
    }
  }

  spec {
    container {
      image = "redis:4.0-alpine"
      name  = "redis-container"
      volume_mount {
        mount_path = "/data"
        name = "redis-volume"
      }
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
    name = "redis-service"
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

resource "kubernetes_pod" "solr_pod" {
  depends_on = ["azurerm_role_assignment.acr_read"]
  metadata {
    name = "solr-pod"
    labels {
      app = "Solr"
    }
  }

  spec {
    container {
      image = "data2paperacrlive.azurecr.io/solr"
      name  = "solr-container"
      volume_mount {
        mount_path = "/solr_data"
        name = "solr-volume"
      }
    }
    volume {
      name = "solr-volume"
      persistent_volume_claim {
        claim_name = "${kubernetes_persistent_volume_claim.solr_pvc.metadata.0.name}"
      }
    }
  }
}

resource "kubernetes_service" "solr_service" {
  metadata {
    name = "solr-service"
  }
  spec {
    selector {
      app = "${kubernetes_pod.solr_pod.metadata.0.labels.app}"
    }
    port {
      port = 8983
      target_port = 8983
    }
  }
}

resource "kubernetes_pod" "postgres_pod" {
  depends_on = ["azurerm_role_assignment.acr_read"]

  metadata {
    name = "postgres-pod"
    labels {
      app = "Postgres"
    }
  }

  spec {
    container {
      image = "data2paperacrlive.azurecr.io/postgres"
      name  = "postgres-container"
      volume_mount {
        mount_path = "/var/lib/postgresql/data"
        sub_path = "postgres_data"
        name = "postgres-volume"
      }
      env {
        name = "POSTGRES_USER"
        value = "${var.POSTGRES_USER}"
      }
      env {
        name = "POSTGRES_PASSWORD"
        value = "${var.POSTGRES_PASSWORD}"
      }
      env {
        name = "DATA2PAPER_PASSWORD"
        value = "${var.DATA2PAPER_PASSWORD}"
      }
      env {
        name = "FEDORA_COMMONS_PASSWORD"
        value = "${var.FEDORA_COMMONS_PASSWORD}"
      }
    }
    volume {
      name = "postgres-volume"
      persistent_volume_claim {
        claim_name = "${kubernetes_persistent_volume_claim.postgres_pvc.metadata.0.name}"
      }
    }
  }
}

resource "kubernetes_service" "postgres_service" {
  metadata {
    name = "postgres-service"
  }
  spec {
    selector {
      app = "${kubernetes_pod.postgres_pod.metadata.0.labels.app}"
    }
    port {
      port = 5432
      target_port = 5432
    }
  }
}

resource "kubernetes_pod" "fedora_pod" {
  depends_on = ["azurerm_role_assignment.acr_read"]

  metadata {
    name = "fedora-pod"
    labels {
      app = "Fedora"
    }
  }

  spec {
    container {
      image = "cbeer/fcrepo4:4.7"
      name  = "fedora-container"
      volume_mount {
        mount_path = "/data"
        name = "fedora-volume"
      }
      env {
        name = "JAVA_OPTS"
        value = "${var.JAVA_OPTS}"
      }
    }
    volume {
      name = "fedora-volume"
      persistent_volume_claim {
        claim_name = "${kubernetes_persistent_volume_claim.fedora_pvc.metadata.0.name}"
      }
    }
  }
}

resource "kubernetes_service" "fedora_service" {
  metadata {
    name = "fedora-service"
  }
  spec {
    selector {
      app = "${kubernetes_pod.fedora_pod.metadata.0.labels.app}"
    }
    port {
      port = 8080
      target_port = 8080
    }
  }
}

resource "kubernetes_pod" "rails_pod" {
  depends_on = ["azurerm_role_assignment.acr_read"]

  metadata {
    name = "rails-pod"
    labels {
      app = "Rails"
    }
  }

  spec {
    container {
      image = "data2paperacrlive.azurecr.io/rails_app"
      name  = "rails-container"
      volume_mount {
        mount_path = "/data2paper/derivatives"
        name = "d2p-derivatives-volume"
      }
      volume_mount {
        mount_path = "/data2paper/uploads"
        name = "d2p-uploads-volume"
      }
      env {
        name = "POSTGRES_HOST"
        value = "${var.POSTGRES_HOST}"
      }
      env {
        name = "POSTGRES_D2P_USER"
        value = "${var.POSTGRES_D2P_USER}"
      }
      env {
        name = "POSTGRES_D2P_PASSWORD"
        value = "${var.POSTGRES_D2P_PASSWORD}"
      }
      env {
        name = "SECRET_KEY_BASE"
        value = "${var.SECRET_KEY_BASE}"
      }
      env {
        name = "HOST"
        value = "${var.HOST}"
      }
      env {
        name = "SOLR_DEVELOPMENT_URL"
        value = "${var.SOLR_DEVELOPMENT_URL}"
      }
      env {
        name = "SOLR_TEST_URL"
        value = "${var.SOLR_TEST_URL}"
      }
      env {
        name = "SOLR_PRODUCTION_URL"
        value = "${var.SOLR_PRODUCTION_URL}"
      }
      env {
        name = "FEDORA_DEVELOPMENT_URL"
        value = "${var.FEDORA_DEVELOPMENT_URL}"
      }
      env {
        name = "FEDORA_TEST_URL"
        value = "${var.FEDORA_TEST_URL}"
      }
      env {
        name = "FEDORA_PRODUCTION_URL"
        value = "${var.FEDORA_PRODUCTION_URL}"
      }
      env {
        name = "REDIS_DEVELOPMENT_HOST"
        value = "${var.REDIS_DEVELOPMENT_HOST}"
      }
      env {
        name = "REDIS_DEVELOPMENT_PORT"
        value = "${var.REDIS_DEVELOPMENT_PORT}"
      }
      env {
        name = "REDIS_TEST_HOST"
        value = "${var.REDIS_TEST_HOST}"
      }
      env {
        name = "REDIS_TEST_PORT"
        value = "${var.REDIS_TEST_PORT}"
      }
      env {
        name = "REDIS_PRODUCTION_HOST"
        value = "${var.REDIS_PRODUCTION_HOST}"
      }
      env {
        name = "REDIS_PRODUCTION_PORT"
        value = "${var.REDIS_PRODUCTION_PORT}"
      }
    }
    volume {
      name = "d2p-derivatives-volume"
      persistent_volume_claim {
        claim_name = "${kubernetes_persistent_volume_claim.d2p_derivatives_pvc.metadata.0.name}"
      }
    }
    volume {
      name = "d2p-uploads-volume"
      persistent_volume_claim {
        claim_name = "${kubernetes_persistent_volume_claim.d2p_uploads_pvc.metadata.0.name}"
      }
    }
  }
}

resource "kubernetes_service" "rails_service" {
  metadata {
    name = "rails-service"
  }
  spec {
    selector {
      app = "${kubernetes_pod.rails_pod.metadata.0.labels.app}"
    }
    port {
      port = 3000
      target_port = 3000
    }
  }
}
