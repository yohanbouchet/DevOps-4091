#!/usr/bin/env bash
# Fichier : terraform/ubuntu-vm/cloud-init/generate.sh
# Rôle    : fabrique cloud-init.img en y insérant la clé SSH publique
# Utilise : user-data.yml, meta-data.yml, envsubst, cloud-localds
# Utilisé par : l'utilisateur, avant terraform apply (voir README)

# Arrêt à la première erreur, variable inconnue ou commande ratée
set -euo pipefail

# Dossier du script : il fonctionne d'où qu'on le lance
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Clé publique à installer ; modifiable : PUBLIC_KEY_FILE=... ./generate.sh
PUBLIC_KEY_FILE="${PUBLIC_KEY_FILE:-$HOME/.ssh/p5_vm_ed25519.pub}"

if [[ ! -r "$PUBLIC_KEY_FILE" ]]; then
  echo "Error: public key not found: $PUBLIC_KEY_FILE" >&2
  exit 1
fi

# Fichier temporaire, supprimé à la sortie même en cas d'erreur
RENDERED="$(mktemp)"
trap 'rm -f "$RENDERED"' EXIT

# Remplace ${SSH_PUBLIC_KEY} par le contenu de la clé publique
# Apostrophes voulues : envsubst doit recevoir le nom de la variable
# shellcheck disable=SC2016
SSH_PUBLIC_KEY="$(cat "$PUBLIC_KEY_FILE")" envsubst '${SSH_PUBLIC_KEY}' \
  < "$SCRIPT_DIR/user-data.yml" > "$RENDERED"

# Disque lu par cloud-init au premier démarrage de la VM
cloud-localds "$SCRIPT_DIR/cloud-init.img" "$RENDERED" \
  "$SCRIPT_DIR/meta-data.yml"
echo "cloud-init.img generated with key: $PUBLIC_KEY_FILE"
