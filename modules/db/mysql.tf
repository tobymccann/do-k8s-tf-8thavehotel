resource "digitalocean_database_cluster" "mysql" {
  name       = var.do_db_cluster_name
  engine     = "mysql"
  size       = var.do_db_size
  region     = var.do_region
  node_count = var.do_db_node_count
}

provider "mysql" {
  endpoint = "${digitalocean_database_cluster.mysql.host}:${digitalocean_database_cluster.mysql.port}"
  username = digitalocean_database_cluster.mysql.user
  password = digitalocean_database_cluster.mysql.password
  tls = "skip-verify"
}

# Create a Database
resource "mysql_database" "wordpress" {
  name = "wordpress"
  default_character_set = "utf8"
  default_collation = "utf8_unicode_ci"
}