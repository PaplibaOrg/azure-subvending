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
│   │   ├── sub-alias-create/        # Subscription alias creation module
│   │   └── sub-move/                 # Subscription management group move module
│   └── services/
│       └── landing-zone/             # Landing zone orchestration module
├── lz/                              # Landing zone deployment files
│   ├── dev-plb-root/                # Dev environment root
│   │   ├── main.tf                  # Main deployment file
│   │   ├── provider.tf              # Terraform backend and provider config
│   │   └── platform/                # Platform subscriptions
│   │       └── management/
│   │           └── platform/
│   │               └── <subscription-name>.json # Subscription configuration
│   ├── test-plb-root/               # Test environment root
│   └── plb-root/                    # Production environment root
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

This repository implements subscription alias management following CAF best practices:

1. **Subscription Alias Management**: Create and manage aliases for existing Azure subscriptions
2. **Management Group Placement**: Automatically move subscriptions to appropriate management groups
3. **Simplified Configuration**: Minimal configuration required - just subscription name and management group
4. **Optional Subscription ID**: Subscription ID can be provided or automatically looked up by name

## Prerequisites

- Azure subscription with permissions to manage subscription aliases
- Existing Azure subscriptions (this module creates aliases for existing subscriptions)
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

   Create JSON files in the appropriate directory structure (e.g., `lz/dev-plb-root/platform/management/platform/`), named as `<subscription-name>.json`:

   ```json
   {
     "subscription_id": "12345678-1234-1234-1234-123456789012",
     "subscription_name": "plb-platform-dev-001",
     "management_group": "/providers/Microsoft.Management/managementGroups/dev-plb-platform"
   }
   ```

   **Note:** `subscription_id` is optional. If not provided, it will be looked up by `subscription_name`.

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
   # Subscription Contributor or Owner role on the subscriptions to manage
   az role assignment create \
     --assignee <managed-identity-principal-id> \
     --role "Subscription Contributor" \
     --scope /subscriptions/{subscription-id}
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

### Resource Modules

#### `modules/resources/sub-alias-create/`

Creates an alias for an existing Azure Subscription.

**Variables:**
- `subscription_name` - Display name of the subscription
- `subscription_id` - ID of the existing subscription (optional, will be looked up by name if not provided)
- `alias` - Alias name for the subscription (typically same as subscription_name)

**Outputs:**
- `subscription_id` - The ID of the subscription
- `subscription_name` - The display name of the subscription
- `subscription_alias` - The alias of the subscription

#### `modules/resources/sub-move/`

Moves a subscription to a management group.

**Variables:**
- `subscription_id` - ID of the subscription to move (in `/subscriptions/{uuid}` format)
- `management_group_id` - Management group ID where the subscription should be moved

**Outputs:**
- `id` - The ID of the management group subscription association
- `management_group_id` - The management group ID
- `subscription_id` - The subscription ID

### Service Module (`modules/services/landing-zone/`)

Orchestrates subscription alias creation and management group placement.

**Variables:**
- `subscription_name` - Display name of the subscription
- `subscription_id` - ID of the existing subscription (optional, will be looked up by name if not provided)
- `management_group_id` - Management group ID where the subscription should be placed

**Outputs:**
- `subscription_id` - The ID of the subscription
- `subscription_name` - The display name of the subscription
- `subscription_alias` - The alias of the subscription
- `sub_move_id` - The ID of the management group subscription association

## Configuration Files

### JSON Configuration Format

Each subscription JSON file (named as `<subscription-name>.json`, e.g., `plb-platform-dev-001.json`) contains subscription-specific configuration:

```json
{
  "subscription_id": "12345678-1234-1234-1234-123456789012",
  "subscription_name": "plb-platform-dev-001",
  "management_group": "/providers/Microsoft.Management/managementGroups/dev-plb-platform"
}
```

**Fields:**
- `subscription_name` (required) - Display name of the subscription
- `subscription_id` (optional) - ID of the existing subscription. If not provided, will be looked up by `subscription_name`
- `management_group` (required) - Management group ID where the subscription should be placed

The `main.tf` automatically reads all JSON files from subdirectories and creates aliases for each subscription configuration.

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
- ✅ Subscription IDs can be stored in configuration files or looked up automatically by name

## Troubleshooting

**Issue:** "Insufficient permissions to manage subscription"
- **Solution:** Verify managed identity has "Subscription Contributor" or "Owner" role on the subscription

**Issue:** "Subscription not found" or "Subscription alias not found"
- **Solution:** Verify subscription_id in JSON file is correct (if provided) or ensure subscription with the specified name exists. Use `terraform import` to import existing aliases into state.

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


