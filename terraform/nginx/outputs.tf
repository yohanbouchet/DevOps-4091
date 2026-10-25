# Fichier : terraform/nginx/outputs.tf
# Rôle    : informations affichées à la fin de terraform apply
# Utilise : main.tf (ressources), variables.tf (var.host_port)
# Utilisé par : terraform output, l'utilisateur

# Identifiant du conteneur, à comparer avec docker ps / docker inspect
output "container_id" {
  description = "ID of the Nginx container"
  value       = docker_container.nginx.id
}

# Adresse à ouvrir dans le navigateur
output "url" {
  description = "URL to reach Nginx"
  value       = "http://localhost:${var.host_port}"
}
