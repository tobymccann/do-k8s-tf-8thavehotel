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
    token = var.do_token
    spaces_access_id  = var.access_id
    spaces_secret_key = var.secret_key
}

module "db" {
    source = "../../modules/db"
    do_db_cluster_name = var.do_db_cluster_name
    do_db_size = var.do_db_size
    do_db_node_count = var.do_db_node_count
    do_region = var.do_region
}

resource "digitalocean_spaces_bucket" "gltd-prd-wp-spaces" {
  name   = var.do_spaces_name
  region = var.do_spaces_region
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