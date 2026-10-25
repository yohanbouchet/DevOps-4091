# Fichier : terraform/ubuntu-vm/variables.tf
# Rôle    : valeurs réglables de la VM Ubuntu (image, réseau, ports)
# Utilise : rien
# Utilisé par : main.tf, outputs.tf

# Nom du conteneur qui fait tourner la VM
variable "container_name" {
  description = "Name of the container running the VM"
  type        = string
  default     = "p5-ubuntu-vm"
}

# Image Docker de QEMU, épinglée (l'image du kit n'existe plus)
variable "qemu_image" {
  description = "QEMU container image"
  type        = string
  default     = "qemux/qemu:7.50"
}

# Image système Ubuntu 24.04 LTS (cloud image officielle)
variable "ubuntu_image_url" {
  description = "Ubuntu cloud image downloaded at first boot"
  type        = string
  default     = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.vmdk"
}

# Adresse d'écoute des ports publiés : la machine seule (pas le réseau local)
variable "listen_address" {
  description = "Host address the published ports listen on"
  type        = string
  default     = "127.0.0.1"
}

# SSH de la VM (port 22) joignable sur ce port de l'hôte, pour Ansible
variable "ssh_port" {
  description = "Host port mapped to the VM SSH port 22"
  type        = number
  default     = 2222
}

# Site web de la VM (port 80) joignable sur ce port de l'hôte
variable "http_port" {
  description = "Host port mapped to the VM HTTP port 80"
  type        = number
  default     = 80
}

# Écran de la VM dans le navigateur (VNC), utile en dépannage
variable "vnc_port" {
  description = "Host port of the web VNC console"
  type        = number
  default     = 8006
}
