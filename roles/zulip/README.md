# ansible.role.zulip

Deploy and manage Zulip using the official Docker stack.

## What this role does

- Creates `/opt/stacks/zulip`
- Creates and persists Zulip secret files under `/opt/stacks/zulip/secrets`
- Renders a compose stack for Zulip + PostgreSQL + Redis + RabbitMQ + Memcached
- Runs one-time `app:init` bootstrap
- Deploys/updates Zulip via Docker Compose
- Installs and allows a role-owned UFW profile (`Zulip`)

## Requirements

- Ubuntu host with Docker Engine and Docker Compose plugin installed
- `community.docker` and `community.general` collections
- `ufw_profiles` role available on the controller

## Key variables

- `zulip_enabled`
- `zulip_http_port`
- `zulip_external_host`
- `zulip_loadbalancer_ips`
- `zulip_redis_uid`
- `zulip_redis_gid`
- `zulip_admin_email`
- `zulip_admin_full_name`
- `zulip_admin_password`
- `zulip_realm_name`
- `zulip_realm_string_id`
- `zulip_email_host`
- `zulip_email_host_user`
- `zulip_email_password`

See `defaults/main.yml` for the full variable surface.

## Note

This role follows Zulip's official Docker architecture. Initial bootstrap can take several minutes.

## License

MIT
