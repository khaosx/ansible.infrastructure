# ansible.role.paperless_stack

Deploy Paperless-ngx as a Docker Compose stack, modeled after https://github.com/timothystewart6/paperless-stack and adapted to this environment's role conventions.

## Scope

This role includes:
- Paperless-ngx
- PostgreSQL
- Redis
- Gotenberg
- Apache Tika
- Optional `paperless-ai`
- Optional `paperless-gpt`

This role intentionally excludes:
- Dozzle
- Ollama
- OpenWebUI

## Purpose

This role:
- Creates a dedicated stack under `/opt/stacks/paperless`
- Renders per-service env files from role variables
- Renders and deploys a Docker Compose project with `community.docker.docker_compose_v2`
- Supports optional AI sidecars that rely on an external model endpoint
- When AI is enabled, bootstraps a Paperless API token at runtime:
  core services up -> token request with admin creds -> stack down -> AI env render -> full stack up

## Requirements

- Ubuntu host with Docker Engine and Compose plugin installed
- `become: true` at play/role inclusion level
- `community.docker` collection available on the controller
- Vault/inventory values for database password and Paperless secret key

## Role Execution Model

This role is intended to run subordinately from a controlling playbook.

The controlling playbook should own:
- Baseline host provisioning
- Docker engine/network lifecycle (must provide external `core` and `proxy` networks)
- Shared inventory/vault structure
- Role ordering and privilege model

## Control Playbook Contract

Defaults are in `defaults/main.yml`.
Controller inventory/vault should override site-specific and secret values.

### Expected upstream variables

| Variable | Required | Description |
|---|---|---|
| `vault_paperless_db_password` | yes | Password for Paperless Postgres user |
| `vault_paperless_secret_key` | yes | Paperless secret key |
| `app_admin_user_pw` or `vault_app_admin_user_pw` | yes | Bootstrap admin password |
| `site_timezone` | no | Time zone (default `UTC`) |
| `admin_email` | no | Bootstrap admin email |

### Optional AI variables

If `paperless_stack_enable_ai=true`, provide:

| Variable | Required | Description |
|---|---|---|
| `paperless_stack_paperless_username` | yes | Paperless username used by AI sidecars |
| `paperless_stack_ai_ollama_url` | yes | External model endpoint URL (e.g. Ollama) |

## Key Variables

- `paperless_stack_dir`
- `paperless_stack_paperless_port`
- `paperless_stack_db_password`
- `paperless_stack_secret_key`
- `paperless_stack_enable_ai`
- `paperless_stack_ai_ollama_url`

See `defaults/main.yml` for complete defaults.

## Example Controller Play

```yaml
---
- name: Deploy Paperless stack
  hosts: paperless
  become: true
  gather_facts: true
  roles:
    - role: paperless_stack
      tags: [paperless, document_management]
```

## License

MIT
