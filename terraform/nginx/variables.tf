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

# Branche stable, variante Alpine (moins de failles) ; l'énoncé proposait
# nginx:latest. En production : épingler aussi l'empreinte (nginx@sha256:...)
variable "nginx_image" {
  description = "Nginx image (stable branch, Alpine variant: fewer CVEs)"
  type        = string
  default     = "nginx:stable-alpine"
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
