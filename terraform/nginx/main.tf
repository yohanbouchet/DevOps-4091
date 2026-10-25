# Fichier : terraform/nginx/main.tf
# Rôle    : décrit l'infrastructure : provider Docker, image Nginx
#           et conteneur exposé sur le port de l'hôte
# Utilise : terraform.tf (versions), variables.tf (var.*)
# Utilisé par : terraform plan / apply, outputs.tf

# Connexion au moteur Docker local par son « socket »
provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Image Nginx téléchargée depuis Docker Hub
resource "docker_image" "nginx" {
  name         = var.nginx_image
  keep_locally = false
}

# Conteneur lancé à partir de l'image ci-dessus
resource "docker_container" "nginx" {
  name  = var.container_name
  image = docker_image.nginx.image_id

  ports {
    # Restreindre l'écoute à la machine locale (désactivé)
    # ip     = "127.0.0.1"
    internal = 80
    external = var.host_port
  }
}
