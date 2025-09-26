#!/bin/bash
#

#!/bin/bash
set -e

# Helper function for step confirmation
confirm_step() {
  echo ""
  echo "Step completed: $1"
  read -p "Approve next step? (y/n): " response
  if [[ "$response" != "y" ]]; then
    echo "Aborting at step: $1"
    exit 1
  fi
}

# Step 1: Login and set subscription
echo "Logging into Azure..."
az login --only-show-errors
az account set --subscription "<your-subscription-id>"
echo "Azure login complete and subscription set."
confirm_step "Azure login and subscription"

# Step 2: Create resource group
echo "Creating resource group..."
az group create --name fintech-pipeline-rg --location eastus
echo "Resource group 'fintech-pipeline-rg' created in East US."
confirm_step "Resource group creation"

# Step 3: Deploy Bicep infrastructure
echo "Deploying Bicep modules..."
az deployment group create \
  --resource-group fintech-pipeline-rg \
  --template-file azure/main.bicep \
  --parameters @azure/parameters/main.bicepparam
echo "Bicep deployment complete."
confirm_step "Bicep infrastructure deployment"

# Step 4: Upload Jupyter notebook to Azure ML
echo "Uploading Jupyter notebook..."
az ml workspace show --name fintech-ml --resource-group fintech-pipeline-rg
az ml job create --file jupyter/fraud_detection.ipynb
echo "Notebook 'fraud_detection.ipynb' uploaded to Azure ML."
confirm_step "Notebook upload"

# Step 5: Register trained model
echo "Registering model..."
az ml model create --name fraud-detector --path models/fraud_detector/
echo "Model 'fraud-detector' registered."
confirm_step "Model registration"

# Step 6: Deploy model as REST endpoint
echo "Creating REST endpoint..."
az ml online-endpoint create --name fraud-api --auth-mode key
az ml online-deployment create \
  --name default \
  --endpoint-name fraud-api \
  --model fraud-detector:1 \
  --instance-type Standard_DS3_v2 \
  --instance-count 1
echo "REST endpoint 'fraud-api' deployed."
confirm_step "Model deployment"

echo ""
echo "All steps completed successfully. Your fintech ML pipeline is live."

