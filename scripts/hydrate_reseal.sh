#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tpl="${repo_root}/group_vars/all/vault.yml.tpl"
out="${repo_root}/group_vars/all/vault.yml"
vault_pass_file="${HOME}/.ansible_vault"

if [[ ! -f "${tpl}" ]]; then
  echo "Missing template: ${tpl}" >&2
  exit 1
fi

if ! command -v ansible-vault >/dev/null 2>&1; then
  echo "Missing ansible-vault in PATH." >&2
  exit 1
fi

if ! command -v op >/dev/null 2>&1; then
  echo "Missing 1Password CLI (op) in PATH." >&2
  exit 1
fi

if [[ ! -f "${vault_pass_file}" ]]; then
  echo "Missing vault password file: ${vault_pass_file}" >&2
  exit 1
fi

# Decrypt if already sealed (no-op if not encrypted)
ansible-vault decrypt --vault-password-file "${vault_pass_file}" "${out}" >/dev/null 2>&1 || true

# Hydrate from 1Password template
op inject -i "${tpl}" -o "${out}" -f

# Re-seal the hydrated file
ansible-vault encrypt --vault-password-file "${vault_pass_file}" "${out}"

echo "Hydrated and sealed: ${out}"
