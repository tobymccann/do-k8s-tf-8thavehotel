###############################################################################
#
# Get variables from command line or environment
#
###############################################################################


variable "do_token" {}
variable "access_id" {}
variable "secret_key" {}
variable "do_region" {
    default = "nyc1"
}
variable "do_spaces_region" {
    default = "nyc3"
}
variable "ssh_fingerprint" {}
variable "ssh_private_key" {
    default = "~/.ssh/do-key-ecdsa"
}

variable "do_spaces_name" {
    description = "DigitalOcean managed objext storage name"
}


variable "do_volume_name" {
    description = "DigitalOcean managed storage volume name"
}

variable "do_volume_size" {
    description = "DigitalOcean managed storage volume size"
}

variable "do_db_cluster_name" {
    description = "DigitalOcean managed database cluster name"
}

variable "do_db_size" {
    description = "DigitalOcean managed database node size slug"
}
variable "do_db_node_count" {
  description = "Count of database cluster nodes"
}

variable "do_k8s_name" {
    description = "DO Kubernetes Cluster Name"
}

variable "k8s_version" {
	description = "DO Kubernetes Version"
    default = "1.15.3-do.3"
}

variable "do_tag_env" {
    description = "DO Environment Tag"
    type = "string"
}

variable "do_tag_cust" {
    description = "DO Customer Tag"
    type = "string"
}

variable "do_tag_pool" {
    description = "DO Pool Type Tag"
    type = "string"
}

variable "k8s_pool_name" {
    description = "DO Kubernetes Default Pool Name"
    type = "string"
}

variable "k8s_node_size" {
    description = "DO Kubernetes node size"
    default = "s-1vcpu-2gb"
}

variable "k8s_node_count" {
    description = "DO Kubernetes Pool Node Count"
    default = 2
}
