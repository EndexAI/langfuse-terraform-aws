# Temporary security configuration backport

This branch starts at upstream `8dba48ea2adbececb988eef7c0bba0592cb28e72`
(1.1.1). It adds configuration inputs without upgrading the application, Helm
chart, providers, or infrastructure defaults, and preserves resource addresses.

The external Aurora parameter-group input is proposed upstream in
[PR 82](https://github.com/langfuse/langfuse-terraform-aws/pull/82).

Additional optional inputs:

| Input | Default | Purpose |
| --- | --- | --- |
| `eks_log_retention_in_days` | `30` | Control-plane log retention |
| `redis_log_retention_in_days` | `7` | Redis log retention |
| `postgres_deletion_protection` | `false` | Aurora deletion protection |
| `postgres_enabled_cloudwatch_logs_exports` | `[]` | Aurora CloudWatch exports; caller owns retention |
| `alb_ssl_policy` | `null` | Listener policy annotation; null leaves it absent |
| `eks_endpoint_public_access` | `true` | Public Kubernetes API endpoint |
| `eks_public_access_cidrs` | `["0.0.0.0/0"]` | Public API source restrictions |

`load_balancer_arn_suffix` exposes the existing ALB for CloudWatch dimensions.
The module still owns the ALB through the Kubernetes controller, not a second
Terraform listener resource. Parameter groups and S3 policies/replication are
caller-owned; do not duplicate ownership of module resources.

Changing parameter groups can require database restarts. Establish TLS clients
before enforcing `rds.force_ssl`; preload and install pgAudit before setting
`pgaudit.log`. Establish private Terraform connectivity before disabling the
public EKS endpoint. These inputs do not orchestrate those operational steps.

Return to an official immutable upstream revision only after all inputs are
available there and a refreshed plan confirms no deletion/replacement, resource
address changes, or unrelated version upgrades. Do not simply revert the source
pin while the caller still uses these inputs.
