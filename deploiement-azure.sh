
# Chargement des variables depuis le Key Vault
export RESOURCE_GROUP=$(az keyvault secret show --vault-name GAE-Vault --name resource-group --query value -o tsv)
export LOCATION=$(az keyvault secret show --vault-name GAE-Vault --name location --query value -o tsv)
export SQL_ADMIN_USER=$(az keyvault secret show --vault-name GAE-Vault --name sql-admin --query value -o tsv)
export SQL_ADMIN_PASSWORD=$(az keyvault secret show --vault-name GAE-Vault --name sql-password --query value -o tsv)
export SQL_SERVER_NAME=$(az keyvault secret show --vault-name GAE-Vault --name db-server --query value -o tsv)
export SQL_DB_NAME=$(az keyvault secret show --vault-name GAE-Vault --name db-name --query value -o tsv)
export REDIS_NAME=$(az keyvault secret show --vault-name GAE-Vault --name redis-host --query value -o tsv)
export APP_PLAN_NAME=$(az keyvault secret show --vault-name GAE-Vault --name app-service-plan --query value -o tsv)
export WEBAPP_NAME=$(az keyvault secret show --vault-name GAE-Vault --name webapp-name --query value -o tsv)
export INSIGHTS_NAME=$(az keyvault secret show --vault-name GAE-Vault --name insights-name --query value -o tsv)
export SUBSCRIPTION_ID=$(az account show --query id -o tsv)

# 0. Création du groupe de ressources
 az group create \
  --name $RESOURCE_GROUP \
  --location "$LOCATION"

# 1. Serveur SQL
 az sql server create \
  --name $SQL_SERVER_NAME \
  --resource-group $RESOURCE_GROUP \
  --location "$LOCATION" \
  --admin-user $SQL_ADMIN_USER \
  --admin-password "$SQL_ADMIN_PASSWORD"

# 2. Base de données SQL
 az sql db create \
  --resource-group $RESOURCE_GROUP \
  --server $SQL_SERVER_NAME \
  --name $SQL_DB_NAME \
  --service-objective S0

# 3. Instance Redis
 az redis create \
  --name $REDIS_NAME \
  --resource-group $RESOURCE_GROUP \
  --location "$LOCATION" \
  --sku Basic \
  --vm-size c0

# 4. Plan App Service Linux
 az appservice plan create \
  --name $APP_PLAN_NAME \
  --resource-group $RESOURCE_GROUP \
  --sku S1 \
  --is-linux

# 5. Web App Node.js
 az webapp create \
  --name $WEBAPP_NAME \
  --plan $APP_PLAN_NAME \
  --resource-group $RESOURCE_GROUP \
  --runtime "NODE|20-lts"

# 6. Application Insights
 az monitor app-insights component create \
  --app $INSIGHTS_NAME \
  --location "$LOCATION" \
  --resource-group $RESOURCE_GROUP \
  --application-type web

# 7. Alerte sur erreurs critiques
 az monitor metrics alert create \
  --name "Prod Payment Errors" \
  --resource-group $RESOURCE_GROUP \
  --scopes /subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Insights/components/$INSIGHTS_NAME \
  --condition "count exceptions/count > 5" \
  --description "Plus de 5 erreurs critiques en 5 min" \
  --evaluation-frequency 1m \
  --window-size 5m \
  --severity 0
