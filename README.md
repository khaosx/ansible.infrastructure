# ansible.infrastructure

Control playbook repository for homelab infrastructure.

## Purpose

This repository is the controller/orchestrator layer. It owns:
- Inventory and variable hierarchy
- Play ordering and host targeting
- Shared configuration conventions
- External role sourcing and versioning

Role implementation lives in dedicated role repositories and is installed locally via `requirements.yml`.

## Execution Model

Primary entrypoint:
- `site.yml`

Current role flow in `site.yml`:
- `provision_ubuntu_2404` on `linux_servers`
- `docker_engine` on `docker`
- `pihole_v6` on `pihole`

## Repository Layout

- `site.yml`: main control playbook
- `ansible_inventory`: inventory source
- `group_vars/`, `host_vars/`: controller-managed vars
- `requirements.yml`: collections and external role sources
- `roles/`: local role development area (optional, temporary)
- `.ansible/roles/`: installed external roles (primary runtime source)
- `scripts/`: helper scripts

## Role Resolution Order

`ansible.cfg` is configured to resolve roles in this order:
1. `./.ansible/roles`
2. `./roles`
3. user/system role paths

That means installed roles in `.ansible/roles` take precedence over local development copies in `./roles`.

## Role Development Workflow

Recommended workflow:
1. Build and iterate in `./roles/<role_name>`.
2. Test from this control playbook.
3. Split/publish to standalone role repo.
4. Add/update role source in `requirements.yml`.
5. Install to `./.ansible/roles`.
6. Remove local `./roles/<role_name>` copy when external role becomes source of truth.

## Setup

Install dependencies:

```bash
ansible-galaxy collection install -r requirements.yml --force
ansible-galaxy role install -r requirements.yml -p ./.ansible/roles --force
```

## Usage

Run full control playbook:

```bash
ansible-playbook -i ansible_inventory site.yml
```

Run scoped targets/examples:

```bash
ansible-playbook -i ansible_inventory site.yml -l docker
ansible-playbook -i ansible_inventory site.yml -l pihole
ansible-playbook -i ansible_inventory site.yml --tags provision
```

## Secrets

This repo uses Ansible Vault and 1Password-assisted hydration.

Key files:
- `group_vars/all/vault.yml.tpl` (template)
- `group_vars/all/vault.yml` (encrypted output)
- `scripts/hydrate_reseal.sh` (helper)

Typical flow:

```bash
op inject -f -i group_vars/all/vault.yml.tpl -o group_vars/all/vault.yml
ansible-vault encrypt group_vars/all/vault.yml
```

## License

MIT
