# vault.yml.tpl
# This file can be committed to git so long as no secrets are added.
# File should be rehydrated with 1PasswordCLI:
# op inject -f -i $HOME/projects/ansible.infrastructure/group_vars/all/vault.yml.tpl -o $HOME/projects/ansible.infrastructure/group_vars/all/vault.yml
#
# Output file should be sealed once hydrated via:
# ansible-vault encrypt $HOME/projects/ansible.infrastructure/group_vars/all/vault.yml
#
#
# Site Secrets
vault_admin_username: "op://khaosx-infrastructure/Admin User/username"
vault_admin_email: "op://khaosx-infrastructure/Application Admin User/email"
vault_site_domain: "op://khaosx-infrastructure/khaosx.io Site Secrets/site_domain"
vault_site_tz: "op://khaosx-infrastructure/khaosx.io Site Secrets/site_tz"

# Automation User Credentials
vault_automation_user_pw: "op://khaosx-infrastructure/Admin User/password"
vault_automation_user_ssh_public_key: "op://khaosx-infrastructure/Admin User/ssh public key"

# App User Credentials
vault_app_admin_user: "op://khaosx-infrastructure/Application Admin User/username"
vault_app_admin_user_pw: "op://khaosx-infrastructure/Application Admin User/password"

# Cloudflare DNS API Credentials
vault_configure_ssl_email: "op://khaosx-infrastructure/Cloudflare API Key - khaosx.io/email"
vault_configure_ssl_cloudflare_api_token: "op://khaosx-infrastructure/Cloudflare API Key - khaosx.io/api_token_secret"

# Pi-hole web UI password hashes (Balloon-SHA256)
vault_pihole_webserver_pwhash: "op://khaosx-infrastructure/Pi-hole Web Password Hashes/webserver_pwhash"
vault_pihole_webserver_app_pwhash: "op://khaosx-infrastructure/Pi-hole Web Password Hashes/webserver_app_pwhash"

# Paperless secrets
vault_paperless_db_password: "op://khaosx-infrastructure/Paperless Secrets/paperless_db_password"
vault_paperless_secret_key: "op://khaosx-infrastructure/Paperless Secrets/paperless_secret_key"
