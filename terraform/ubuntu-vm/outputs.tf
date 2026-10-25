# Fichier : terraform/ubuntu-vm/outputs.tf
# Rôle    : informations de connexion affichées après terraform apply
# Utilise : variables.tf
# Utilisé par : l'utilisateur, inventaire Ansible (hosts)

# Commande SSH prête à copier
output "ssh_command" {
  description = "SSH command to connect to the VM"
  value       = "ssh -i ~/.ssh/p5_vm_ed25519 -p ${var.ssh_port} ansible@${var.listen_address}"
}

# Site web servi par la VM (après le playbook Ansible)
output "web_url" {
  description = "URL of the website served by the VM"
  value       = "http://${var.listen_address}:${var.http_port}"
}

# Écran de la VM dans le navigateur, pour dépanner
output "vnc_url" {
  description = "URL of the web VNC console"
  value       = "http://${var.listen_address}:${var.vnc_port}"
}
