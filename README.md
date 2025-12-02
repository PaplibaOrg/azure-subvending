# Azure Subscription Vending

Terraform infrastructure-as-code for Azure Subscription Vending following Azure Cloud Adoption Framework (CAF) best practices.

## Overview

This repository provides Terraform modules to automate the creation and management of Azure subscriptions according to CAF recommendations. It follows the same structure and patterns as the `azure-iam` repository for consistency.

## Repository Structure

```
azure-subvending/
├── .husky/                          # Git hooks for commit linting
├── .instructions/                    # Platform standards and guidelines
├── modules/
│   ├── resources/
│   │   └── subscription/            # Single subscription resource module
│   └── services/
│       └── subscriptions/            # Subscription orchestration module
├── lz/                              # Landing zone deployment files
│   ├── main.tf                      # Main deployment file
│   ├── provider.tf                  # Terraform backend and provider config
│   └── dev-plb-root/
│       └── landingzones/
│           └── corp/                # Corporate landing zones
│               └── <application>/   # Application folders (e.g., platform)
│                   └── <subscription-name>.json # Subscription configuration (e.g., plb-platform-dev-001.json)
├── pipeline/
│   ├── deploy-subscriptions.yaml
│   └── templates/
│       └── deploy-terraform.yaml
├── .gitignore
├── commitlint.config.js
├── package.json
└── README.md
```

## CAF Subscription Vending Principles

This repository implements subscription vending following CAF best practices:

1. **Subscription Democratization**: Enable application teams to request subscriptions through a standardized process
2. **Management Group Placement**: Automatically place subscriptions in appropriate management groups
3. **Naming Convention**: Follow consistent naming pattern: `sub-{app}-{region}-{env}-{seq}`
4. **Tagging Strategy**: Apply consistent tags for governance and cost management
5. **Billing Scope**: Associate subscriptions with appropriate billing scopes

## Prerequisites

- Azure subscription with Subscription Contributor role
- Billing account access (for subscription creation)
- Terraform >= 1.0
- Azure CLI installed and configured
- Azure DevOps with self-hosted agent pool (`default`)
- User-assigned managed identity: `id-sub-vending-eus-dev-001` (for dev environment)
- Node.js and npm (for commit linting)

## Getting Started

### Initial Setup

```bash
# Clone the repository
git clone https://github.com/PaplibaOrg/azure-subvending.git
cd azure-subvending

# Install git hooks for commit message validation
npm install
```

### Configuration

1. **Create Subscription Configuration Files**

   Create JSON files in `lz/dev-plb-root/landingzones/corp/<application>/` directory, named as `<subscription-name>.json`:

   ```json
   {
     "application": "platform",
     "environment": "dev",
     "sequence": "001",
     "location": "eastus",
     "billing_scope_id": "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}",
     "management_group_id": "/providers/Microsoft.Management/managementGroups/dev-plb-platform",
     "tags": {
       "owner": "sunny.bharne",
       "application": "vending"
     },
     "additional_tags": {
       "costCenter": "platform",
       "project": "subscription-vending"
     }
   }
   ```

2. **Update Terraform Backend**

   Edit `lz/provider.tf` to configure your Terraform state backend:

   ```hcl
   terraform {
     backend "azurerm" {
       resource_group_name  = "rg-tf-state-eus-dev-001"
       storage_account_name = "sttfstateeusdev001"
       container_name       = "tfstate"
       key                  = "subscriptions-dev.tfstate"
     }
   }
   ```

## Deployment

### Azure DevOps Pipeline (Recommended)

The repository uses a template-based pipeline with Terraform Plan → Apply pattern:

**Pipeline Flow:**
```
Dev:  Plan_Sub_Dev → Apply_Sub_Dev
Test: Plan_Sub_Test → Approval_Test → Apply_Sub_Test (when configured)
Prod: Plan_Sub_Prod → Approval_Prod → Apply_Sub_Prod (when configured)
```

**Setup Steps:**

1. **Configure Service Connection** in Azure DevOps:
   - Name: `id-sub-vending-eus-dev-001` (for dev)
   - Type: Azure Resource Manager (Workload Identity Federation)
   - Managed Identity: User-assigned managed identity

2. **Assign Permissions** to the managed identity:
   ```bash
   # Subscription Contributor at billing account level
   az role assignment create \
     --assignee <managed-identity-principal-id> \
     --role "Subscription Contributor" \
     --scope /providers/Microsoft.Billing/billingAccounts/{billingAccountName}
   ```

3. **Create Azure DevOps Environments**:
   - Pipelines → Environments → Create:
     - `Dev` (no approval)
     - `Test` (optional approval)
     - `Prod` (add approval checks)

4. **Create Pipeline** in Azure DevOps:
   - Pipelines → New Pipeline → Azure Repos Git
   - Select repository → Existing Azure Pipelines YAML file
   - Path: `/pipeline/deploy-subscriptions.yaml`

5. **Run Pipeline**: Push to `main` branch or manually trigger

### Manual Deployment (Local)

```bash
cd lz

# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply the configuration
terraform apply
```

## Module Structure

### Resource Module (`modules/resources/subscription/`)

Creates a single Azure Subscription and associates it with a management group.

**Variables:**
- `subscription_name` - Display name of the subscription
- `billing_scope_id` - Billing scope ID
- `management_group_id` - Management group ID for placement
- `tags` - Tags to apply

### Service Module (`modules/services/subscriptions/`)

Orchestrates subscription creation with standardized naming and tagging.

**Variables:**
- `application` - Application name/key
- `environment` - Environment name (dev, test, prod)
- `sequence` - Sequence number for naming
- `location` - Azure region
- `billing_scope_id` - Billing scope ID
- `management_group_id` - Management group ID (derived automatically from environment and application)
- `tags` - Tags object (owner, application, and any additional keys)

**Outputs:**
- Subscription ID, name, and alias

## Subscription Naming Convention

Subscriptions follow the pattern: `sub-{application}-{region}-{environment}-{sequence}`

**Examples:**
- `sub-platform-eus-dev-001` - Platform application, East US, Dev environment
- `sub-app1-wus-prod-001` - App1 application, West US, Prod environment

## Configuration Files

### JSON Configuration Format

Each subscription JSON file (named as `<subscription-name>.json`, e.g., `plb-platform-dev-001.json`) contains subscription-specific configuration:

```json
{
  "application": "platform",
  "environment": "dev",
  "sequence": "001",
  "location": "eastus",
  "billing_scope_id": "/providers/Microsoft.Billing/...",
  "tags": {
    "owner": "sunny.bharne",
    "application": "vending",
    "costCenter": "platform"
  }
}
```

The `main.tf` automatically reads all JSON files from subdirectories and creates subscriptions for each configuration.

## Development Workflow

### Commit Messages

All commits must follow [Conventional Commits](https://www.conventionalcommits.org/) format:

```bash
# Good examples
git commit -m "feat: add new subscription configuration"
git commit -m "fix: update billing scope ID"
git commit -m "docs: update README"

# Bad examples (rejected by git hooks)
git commit -m "updated stuff"
git commit -m "fix"
```

### Making Changes

1. Create a feature branch:
   ```bash
   git checkout -b feature/your-feature
   ```

2. Make changes to Terraform modules or configuration files

3. Test locally:
   ```bash
   cd lz
   terraform init
   terraform plan
   ```

4. Commit with conventional commit message (validated automatically)

5. Push and create pull request

## Security Considerations

- ✅ Use managed identities for service connections (no secrets in code)
- ✅ Service connections secured in Azure DevOps
- ✅ Least privilege role assignments
- ✅ State files stored in secure Azure Storage backend
- ✅ Billing scope restrictions prevent unauthorized subscription creation

## Troubleshooting

**Issue:** "Insufficient permissions to create subscription"
- **Solution:** Verify managed identity has "Subscription Contributor" role at billing account level

**Issue:** "Billing scope not found"
- **Solution:** Verify billing scope ID is correct and accessible

**Issue:** "Management group not found"
- **Solution:** Ensure management group exists before creating subscription

**Issue:** "State locked" error
- **Solution:** Check for stuck locks, use `terraform force-unlock` if needed

## Learn More

- [Azure Subscription Vending](https://learn.microsoft.com/azure/architecture/landing-zones/subscription-vending)
- [Programmatically Create Subscriptions](https://learn.microsoft.com/azure/cost-management-billing/manage/programmatically-create-subscription-microsoft-customer-agreement)
- [Cloud Adoption Framework](https://docs.microsoft.com/azure/cloud-adoption-framework/)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Conventional Commits](https://www.conventionalcommits.org/)

## License

ISC


