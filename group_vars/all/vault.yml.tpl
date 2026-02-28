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

# Kubernetes secrets
vault_kubernetes_keepalived_password: "op://khaosx-infrastructure/Kubernetes Secrets/keepalived_password"
vault_kubernetes_ceph_user_key: "op://khaosx-infrastructure/Kubernetes Secrets/ceph_user_key"

# Pi-hole web UI password hashes (Balloon-SHA256)
vault_pihole_webserver_pwhash: "op://khaosx-infrastructure/Pi-hole Web Password Hashes/webserver_pwhash"
vault_pihole_webserver_app_pwhash: "op://khaosx-infrastructure/Pi-hole Web Password Hashes/webserver_app_pwhash"
vault_pihole_admin_password: "op://khaosx-infrastructure/Application Admin User/password"

# Homepage service secrets
vault_homepage_pihole_api_key: "op://khaosx-infrastructure/Pihole API Key/password"
vault_homepage_npm_username: "op://khaosx-infrastructure/Nginx Proxy Manager - Secrets/username"
vault_homepage_npm_password: "op://khaosx-infrastructure/Nginx Proxy Manager - Secrets/password"
vault_homepage_proxmox_username: "op://khaosx-infrastructure/Proxmox Homepage Monitor API/username"
vault_homepage_proxmox_password: "op://khaosx-infrastructure/Proxmox Homepage Monitor API/password"
vault_homepage_pbs_username: "op://khaosx-infrastructure/Proxmox PBS Homepage Monitor API/username"
vault_homepage_pbs_password: "op://khaosx-infrastructure/Proxmox PBS Homepage Monitor API/password"
vault_homepage_synology_username: "op://khaosx-infrastructure/Synology Homepage Monitoring User/username"
vault_homepage_synology_password: "op://khaosx-infrastructure/Synology Homepage Monitoring User/password"
vault_homepage_plex_key: "op://khaosx-infrastructure/MediaOps Secrets/plex key"
vault_homepage_tautulli_key: "op://khaosx-infrastructure/MediaOps Secrets/tautulli key"
vault_homepage_overseerr_key: "op://khaosx-infrastructure/MediaOps Secrets/overseerr"
vault_homepage_sonarr_hd_key: "op://khaosx-infrastructure/MediaOps Secrets/sonarr hd key"
vault_homepage_radarr_hd_key: "op://khaosx-infrastructure/MediaOps Secrets/radarr hd key"
vault_homepage_radarr_4k_key: "op://khaosx-infrastructure/MediaOps Secrets/radarr 4k"
vault_homepage_sonarr_anime_key: "op://khaosx-infrastructure/MediaOps Secrets/sonarr anime key"
vault_homepage_audiobookshelf_key: "op://khaosx-infrastructure/MediaOps Secrets/audiobookshelf key"
vault_homepage_prowlarr_key: "op://khaosx-infrastructure/MediaOps Secrets/prowlarr key"
vault_homepage_sabnzbd_key: "op://khaosx-infrastructure/MediaOps Secrets/sabnzbd key"
vault_homepage_openweathermap_key: "op://khaosx-infrastructure/Weather API Key/key"
vault_homepage_weatherapi_key: "op://khaosx-infrastructure/Weather API Key/key"
vault_homepage_unifi_api_key: "op://khaosx-infrastructure/Unifi API token - RO Monitoring/api_token_secret"
