# Fichier : terraform/nginx/variables.tf
# Rôle    : valeurs réglables du déploiement Nginx
# Utilise : rien
# Utilisé par : main.tf, outputs.tf

# Nom du conteneur, visible dans docker ps
variable "container_name" {
  description = "Name of the Nginx container"
  type        = string
  default     = "nginx-tf"
}

# Image imposée par l'énoncé ; en production, épingler une version
# (ex. nginx:1.30) pour que chaque déploiement soit identique
variable "nginx_image" {
  description = "Nginx image ('latest' is required by the exercise)"
  type        = string
  default     = "nginx:latest"
}

# Port de la machine hôte relié au port 80 du conteneur (8000 : étape 2)
variable "host_port" {
  description = "Host port mapped to the container port 80"
  type        = number
  default     = 8000

  validation {
    condition     = var.host_port >= 1024 && var.host_port <= 65535
    error_message = "host_port must be between 1024 and 65535."
  }
}
