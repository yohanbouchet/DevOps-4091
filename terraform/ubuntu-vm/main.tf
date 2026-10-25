# Fichier : terraform/ubuntu-vm/main.tf
# Rôle    : VM Ubuntu 24.04 lancée par QEMU dans un conteneur Docker,
#           cible du déploiement Ansible (SSH par clé, ports en local)
# Utilise : terraform.tf, variables.tf, cloud-init/cloud-init.img
# Utilisé par : terraform plan / apply, outputs.tf

# Connexion au moteur Docker local par son « socket »
provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Image Docker de QEMU, le logiciel qui fait tourner la VM
resource "docker_image" "qemu" {
  name         = var.qemu_image
  keep_locally = false
}

# Disque persistant de la VM (système installé, données)
resource "docker_volume" "vm_storage" {
  name = "${var.container_name}-storage"
}

# Conteneur qui fait tourner la VM
resource "docker_container" "vm" {
  name  = var.container_name
  image = docker_image.qemu.image_id

  # Ubuntu à démarrer + disque cloud-init branché en lecture seule
  env = [
    "BOOT=${var.ubuntu_image_url}",
    "ARGUMENTS=-drive if=virtio,format=raw,readonly=on,file=/cloud-init.img",
  ]

  # Accès nécessaires à QEMU : accélération KVM et carte réseau virtuelle
  devices {
    host_path = "/dev/kvm"
  }
  devices {
    host_path = "/dev/net/tun"
  }
  capabilities {
    add = ["NET_ADMIN"]
  }

  # Laisse 2 minutes à la VM pour s'éteindre proprement
  stop_timeout = 120

  # Ports publiés uniquement sur la machine locale (listen_address)
  ports {
    ip       = var.listen_address
    internal = 22
    external = var.ssh_port
  }
  ports {
    ip       = var.listen_address
    internal = 80
    external = var.http_port
  }
  ports {
    ip       = var.listen_address
    internal = 8006
    external = var.vnc_port
  }

  # Disque cloud-init fabriqué par generate.sh, monté en lecture seule
  volumes {
    host_path      = abspath("${path.module}/cloud-init/cloud-init.img")
    container_path = "/cloud-init.img"
    read_only      = true
  }
  # Stockage persistant de la VM
  volumes {
    volume_name    = docker_volume.vm_storage.name
    container_path = "/storage"
  }

  # Refuse l'apply si le disque cloud-init n'a pas été généré
  lifecycle {
    precondition {
      condition     = fileexists("${path.module}/cloud-init/cloud-init.img")
      error_message = "cloud-init.img not found: run cloud-init/generate.sh first."
    }
  }
}
