# AWS Web Application with AWS Shield Protection

Terraform configuration for a multi-account AWS infrastructure with DDoS protection using AWS Shield.

## Architecture

- VPC with public subnets across 2 AZs
- Application Load Balancer
- 2 EC2 instances running Apache
- AWS Shield Advanced protection (multi-account)

## Prerequisites

- Terraform >= 1.0
- AWS CLI configured
- AWS Organizations setup
- OrganizationAccountAccessRole in member accounts
- Appropriate IAM permissions

## Configuration

1. Copy the example variables file:
```bash
cp terraform.tfvars.example terraform.tfvars
```

2. Edit `terraform.tfvars` with your account IDs:
```hcl
member_account_1_id = "123456789012"
member_account_2_id = "123456789013"
```

## Deployment

```bash
terraform init
terraform plan
terraform apply
```

## Shield Protection

### Shield Standard
- Enabled by default (no cost)
- Basic DDoS protection

### Shield Advanced
- ~$3,000/month subscription
- Organization-wide protection
- 24/7 DDoS Response Team (DRT)
- Cost protection

**Files:**
- `shield.tf` - Single account protection
- `shield-multi-account.tf` - Multi-account setup

## Outputs

- `alb_dns_name` - Load balancer DNS endpoint

## Cost Warning

AWS Shield Advanced incurs significant costs. Review pricing before applying.

## Cleanup

```bash
terraform destroy
```

Note: Shield subscription has `skip_destroy = true` to prevent accidental cancellation.
# aws-shield-Deployment
