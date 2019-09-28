###############################################################################
#
# A simple K8s cluster in DO
#
###############################################################################
terraform {
  required_version = "~> 0.12.0"

  backend "remote" {}
}

###############################################################################
#
# Specify provider
#
###############################################################################


provider "digitalocean" {
    token = "${var.do_token}"
}

module "db" {
    source = "../../modules/db"
    do_db_cluster_name = var.do_db_cluster_name
    do_db_size = var.do_db_size
    do_db_node_count = var.do_db_node_count
    do_region = var.do_region
}

resource "digitalocean_volume" "DO_PV" {
  region                  = var.do_region
  name                    = var.do_volume_name
  size                    = var.do_volume_size
  initial_filesystem_type = "ext4"
  description             = "K8S Frontend PVC Volume"
}


resource "digitalocean_kubernetes_cluster" "tf-k8s-cluster" {
  name    = var.do_k8s_name
  region  = var.do_region
  version = var.k8s_version
  tags    = [var.do_tag_env, var.do_tag_cust]

  node_pool {
    name       = var.k8s_pool_name
    size       = var.k8s_node_size
    node_count = var.k8s_node_count
    tags       = [var.do_tag_env, var.do_tag_pool]
  }
}

provider "kubernetes" {
  host = "${digitalocean_kubernetes_cluster.tf-k8s-cluster.endpoint}"

  client_certificate     = "${base64decode(digitalocean_kubernetes_cluster.tf-k8s-cluster.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(digitalocean_kubernetes_cluster.tf-k8s-cluster.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(digitalocean_kubernetes_cluster.tf-k8s-cluster.kube_config.0.cluster_ca_certificate)}"
}