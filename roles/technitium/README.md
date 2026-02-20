# ansible.role.technitium

Install and manage Technitium DNS Server on Ubuntu hosts.

## What this role does

- Installs Technitium DNS Server and enables systemd service.
- Optionally configures UFW rules using the `ufw_profiles` role.
- Optionally manages DNS node entries in `/etc/hosts`.
- Optionally configures TLS certificates (Let's Encrypt DNS-01 via Cloudflare).
- Builds/refreshes Technitium PFX material for HTTPS service usage.
- Enforces Technitium UI/API auth to `app_admin_user` / `app_admin_user_pw`.
- Configures Technitium web TLS binding via API (`:53443` by default).

## Key variables

- `technitium_service_name`
- `technitium_install_script_url`
- `technitium_ufw_profiles_catalog`
- `technitium_ufw_allow_applications`
- `technitium_tls_enabled`
- `technitium_tls_domain`
- `technitium_tls_cloudflare_api_token`
- `technitium_manage_auth`
- `technitium_auth_target_user`
- `technitium_auth_target_password`
- `technitium_configure_web_tls_via_api`
- `technitium_web_service_tls_port`

See `defaults/main.yml` for full defaults.

TLS defaults are host-specific: each node requests a certificate for its own
hostname/FQDN by default (no wildcard SAN by default).

## Notes

- This role expects `become: true`.
- TLS workflow requires valid Cloudflare DNS API token and ACME email values.
