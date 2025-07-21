# Script de création des secrets dans le Key Vault GAE-Vault

az keyvault secret set --vault-name GAE-Vault --name resource-group --value "GAE-lab"

az keyvault secret set --vault-name GAE-Vault --name location --value "France Central"

az keyvault secret set --vault-name GAE-Vault --name sql-admin --value "adminbrief"

az keyvault secret set --vault-name GAE-Vault --name sql-password --value "DevOps@2024!"

az keyvault secret set --vault-name GAE-Vault --name db-server --value "prodsql-$(whoami)"

az keyvault secret set --vault-name GAE-Vault --name db-name --value "prod-db"

az keyvault secret set --vault-name GAE-Vault --name redis-host --value "techmart-cache-$(whoami)"

az keyvault secret set --vault-name GAE-Vault --name app-service-plan --value "app-plan-prod"

az keyvault secret set --vault-name GAE-Vault --name webapp-name --value "prod-api-$(whoami)"

az keyvault secret set --vault-name GAE-Vault --name insights-name --value "prod-insights"
