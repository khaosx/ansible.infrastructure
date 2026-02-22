# k8s-services - Agent Prompt

This document defines the implementation contract for `roles/k8s-services`.
Follow it exactly when creating or changing this role.

## Scope

- Deploy and manage Kubernetes workloads on an existing cluster.
- This role does not bootstrap the cluster and does not modify cluster connectivity behavior.
- Keep `ansible.infrastructure` as the source of truth unless explicit promotion is requested.

## Non-Negotiable Constraints

- Do not change Ansible SSH behavior, `ansible.cfg` connection settings, known-host handling, or git transport behavior.
- Treat connection failures as diagnostics first. Report findings before proposing connectivity changes.
- Do not make destructive changes unless explicitly authorized.
- Do not deploy workloads to the `default` namespace.

## Cluster Facts

- Kubernetes: `1.32.x`
- Control plane nodes: `ctrl-01`, `ctrl-02`, `ctrl-03`
- Worker nodes: `work-01`, `work-02`, `work-03`
- Ingress: Traefik (`IngressClass=traefik`, namespace `traefik`)
- LoadBalancer: MetalLB L2, pool `10.0.20.30-10.0.20.39`
- API endpoint VIP: `10.0.20.246:6443` (not for app ingress DNS)
- Cluster domain: `khaosx.io`
- Default block storage class: `ceph-rbd` (`ReadWriteOnce`)
- Shared file storage: NFS CSI (`ReadWriteMany`, static PV workflow)
- cert-manager ClusterIssuers: `letsencrypt-prod`, `letsencrypt-staging`

## Ansible Style Contract

- Role defaults belong in `defaults/main.yml`.
- Do not add compatibility aliases for variables unless explicitly requested.
- Prefer `import_tasks` for static task layout.
- Use tags per service and keep them consistent.
- Escalation model:
  - Role contract: `requires_become: true`
  - Set escalation at play/include level.
  - Avoid repetitive per-task `become: true` unless mixed-privilege behavior is required.

## Required Role Variables

Define and use these inputs in `defaults/main.yml`:

```yaml
k8s_services_delegate_host: "ctrl-01"
k8s_services_kubeconfig: "/etc/kubernetes/admin.conf"
k8s_services_ingress_class: "traefik"
k8s_services_domain: "khaosx.io"
k8s_services_services: []
```

`k8s_services_services` should contain per-service dictionaries (name, namespace, enabled, manifests, optional tags, optional readiness targets).

## Recommended Structure

```text
roles/k8s-services/
├── defaults/main.yml
├── tasks/main.yml
├── tasks/validate.yml
├── tasks/service.yml
├── templates/<service>/*.yml.j2
└── README.md
```

`tasks/main.yml` should use static imports:

```yaml
---
- ansible.builtin.import_tasks: validate.yml
  tags: [k8s_services, always]

- ansible.builtin.import_tasks: service.yml
  loop: "{{ k8s_services_services }}"
  loop_control:
    loop_var: k8s_service
  when: k8s_service.enabled | default(true)
  tags: [k8s_services]
```

## Deployment Pattern Per Service

Use `kubernetes.core.k8s` as the default mechanism. Use shell/command only where module support is unavailable.

```yaml
---
- name: Ensure namespace exists
  kubernetes.core.k8s:
    kubeconfig: "{{ k8s_services_kubeconfig }}"
    state: present
    definition:
      apiVersion: v1
      kind: Namespace
      metadata:
        name: "{{ k8s_service.namespace }}"
  delegate_to: "{{ k8s_services_delegate_host }}"

- name: Apply rendered manifests
  kubernetes.core.k8s:
    kubeconfig: "{{ k8s_services_kubeconfig }}"
    state: present
    definition: "{{ lookup('template', item) | from_yaml_all | list }}"
  delegate_to: "{{ k8s_services_delegate_host }}"
  loop: "{{ k8s_service.manifests }}"

- name: Wait for deployment readiness
  ansible.builtin.command: >
    kubectl rollout status deployment/{{ k8s_service.name }}
    -n {{ k8s_service.namespace }}
    --timeout=180s
    --kubeconfig {{ k8s_services_kubeconfig }}
  delegate_to: "{{ k8s_services_delegate_host }}"
  changed_when: false
```

## Workload Standards

- Always set resource requests and limits.
- Always define liveness and readiness probes where supported.
- Keep secrets in Vault-backed variables. Never hardcode credentials.
- Use `Ingress` for HTTP/HTTPS apps.
- Use `LoadBalancer` only for non-HTTP protocols.
- Use `ceph-rbd` for single-writer persistent data and NFS only when shared RW access is required.

## DNS and TLS Rules

- DNS records for web services should resolve to the Traefik Service external IP (MetalLB), not the control plane VIP.
- Do not assume a fixed Traefik IP. Verify current value before documenting or creating DNS records:

```bash
kubectl -n traefik get svc traefik -o jsonpath='{.status.loadBalancer.ingress[0].ip}{"\n"}'
```

- Use cert-manager for certificates.
- For production hosts, use `letsencrypt-prod`.
- For test environments, use `letsencrypt-staging`.

## Validation Checklist

Run these checks from the delegate host after deployment:

```bash
kubectl get ns
kubectl get pods -A
kubectl get ingress -A
kubectl get svc -n traefik
kubectl get certificate -A
```

Role completion criteria:

- Re-running the role is idempotent.
- All enabled services deploy in their own namespaces.
- Readiness checks pass for each enabled service.
- Ingress and TLS are configured for each exposed HTTP service.
