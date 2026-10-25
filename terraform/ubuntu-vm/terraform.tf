# Fichier : terraform/ubuntu-vm/terraform.tf
# Rôle    : fixe les versions de Terraform et du provider Docker
# Utilise : registre Terraform (provider kreuzwerker/docker)
# Utilisé par : terraform init (téléchargement du provider)

terraform {
  # Versions de Terraform acceptées : 1.17 ou plus, mais pas la 2.0
  required_version = "~> 1.17"

  required_providers {
    # Provider Docker : traduit le code Terraform en ordres pour Docker
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 4.6"
    }
  }
}
