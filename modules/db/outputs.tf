output "mysql-cluster_host" {
  value = digitalocean_database_cluster.mysql.host
}

output "mysql-cluster_port" {
  value = digitalocean_database_cluster.mysql.port
}

output "mysql-cluster_uri" {
  value = digitalocean_database_cluster.mysql.uri
}

output "mysql-cluster_database" {
  value = digitalocean_database_cluster.mysql.database
}

output "mysql-cluster_user" {
  value = digitalocean_database_cluster.mysql.user
}
 output "mysql-cluster_passwd" {
   value = digitalocean_database_cluster.mysql.password
 }