# Recreate deployment

## Deploy auxiliary Azure resources

CICD workflow depends on Azure resources to support the deployment. An Azure storage account to store Terraform statefile and a Key Vault to store secrets is deployed through [ARM template](https://github.com/DFE-Digital/tra-shared-services/blob/main/azure/resourcedeploy.json). For each environment needed for the service (eg: dev, test, preprod, production) run the make command from the root of the repository:

```bash
make dev deploy-azure-resources CONFIRM_DEPLOY=1
```

_Note : environments deployed to test (s165-teachingqualificationsservice-test) and production (s165-teachingqualificationsservice-production) subscriptions will require PIM access._

## Create service principals for the service on each CIP subscription

All service environment deployments ends up in one of the three TRA CIP subscriptions **s165-teachingqualificationsservice-development**,**s165-teachingqualificationsservice-test**, **s165-teachingqualificationsservice-production**. A service principal (App registration) on Azure AD is created for each service per subscription. For example access your teaching profile has the following:

- s165d01-aytp-contributor
- s165t01-aytp-contributor
- s165p01-aytp-contributor

Using the Azure CLI create a service principal in the appropriate subscription:

```bash
az account set --subscription <subscription name>
az ad sp create-for-rbac --name <principal name> --skip-assignment --sdk-auth
```

### Example

```bash
az account set --subscription s165-teachingqualificationsservice-development
az ad sp create-for-rbac --name s165d01-aytp-contributor --skip-assignment --sdk-auth
```

The final command should output a JSON object containing `clientId`, `clientSecret`, `subscriptionId` and `tenantId`.

_Note: Please ensure you add the **Infrastructure Team** members as owners on the App registration. This will ensure other people will have access if the person created the SP left Azure AD._

### Assign Azure AD roles to Service Principal

The Service principals created above should be assigned three Azure AD roles for it to be used on GitHub Actions workflow. `Contributor`, `Key Vault Reader`, and `Key Vault Secret Officer`. First an approval from the security team is required for the CIP team to assign the AD roles:

1. Send an email to the **Security Team** and CC **Infrastructure Team** and **CIP Team**. Mention the name of the new service, service principal names, and that the repository on GitHub is owned by DFE-Digital. A contributor AD role is required to deploy Azure resources to the subscriptions.

2. Raise a ServiceNow request to CIP team to assign the roles to all three SPs. It is recommended to create all the SPs and send one request.

   Category: CIP Request
   Request Type: Any Other request

   ### Example

   FAO CIP Team:
   Please give `s165d01-aytp-contributor` service principal `Contributor`, `Key Vault Reader` and `KeyVault Secrets Officer` roles on subscription `s165-teachingqualificationsservice-development`.

   Please give `s165t01-aytp-contributor` service principal `Contributor`, `Key Vault Reader` and `KeyVault Secrets Officer` roles on subscription `s165-teachingqualificationsservice-test`.

   Please give `s165p01-aytp-contributor` service principal `Contributor`, `Key Vault Reader` and `KeyVault Secrets Officer` roles on subscription `s165-teachingqualificationsservice-production`

## Add AZURE_CREDENTIALS secret to the GitHub environments

The JSON output from service principal creation command can be added to the GitHub environments as AZURE_CREDENTIALS. This can then be used in the pipeline to deploy and access KV secrets.

_Note: Please add the JSON to appropriate Key Vault as `SP-Contributor` secret to ensure access to it for future use._

## Create Key Vault secrets for deployment

Deployment of the service environments require some sensitive information such as secrets and passwords stored in Azure Key Vault and fetched during deployment. For example `INFRASTRUCTURE` secret holds the secrets for the app in a key-value yaml format.

To create a new YAML secret run:

```bash
make < environment_name > create-keyvault-secret
```

### Example

```bash
make dev create-keyvault-secret
```

_Note: The name of the secret when running the command is set in `read-keyvault-config` rule and set to **INFRASTRUCTURE** by default._

**MONITORING** secret hold information required for Slack and StatusCake integration.

To edit a YAML secret thats present in the Key Vault, Run:

```bash
make < environment_name > edit-keyvault-secret
```

## Deploy environment

CICD pipeline is setup to deploy Azure infrastructure such app service and postgres database through Terraform on push to the **main** branch.
