#!/bin/bash
## Script to check if SA exists, otherwise create one with given parameters ##

echo "Checking for parameter file"
if [ -f setup-backend.cfg ]
#if [ -f az-parameters.cfg ]
then
  echo "Parameter file present, proceeding with the script"
  source setup-backend.cfg
  echo "Checking if Storage Account exists"
  AZ_SA_NAME=$(az storage account show --name $SA_NAME --resource-group $SA_RESOURCE_GROUP --query 'name' -o tsv)
  if [ ! -z "$AZ_SA_NAME" ] && [ "$AZ_SA_NAME" == "$SA_NAME" ]
  then
    echo "Storage account already exists:" $AZ_SA_NAME
    exit 0
  else
    echo "Checking if Resource Group Exists" $SA_RESOURCE_GROUP
    AZ_SA_RESOURCE_GROUP=$(az group show --name $SA_RESOURCE_GROUP --query 'name' -o tsv)
    if [ ! -z "$AZ_SA_RESOURCE_GROUP" ] && [ "$AZ_SA_RESOURCE_GROUP" == "$SA_RESOURCE_GROUP" ]
    then
      echo "Resource Group already exists:" $AZ_SA_RESOURCE_GROUP
    else
      echo "Creating Resource Group for storage account: " $SA_RESOURCE_GROUP
      az group create --name $SA_RESOURCE_GROUP --location $SA_LOCATION
    fi

    echo "Creating Azure Storage Account" $SA_NAME
    az storage account create --resource-group $SA_RESOURCE_GROUP --name $SA_NAME --sku Standard_LRS --location $SA_LOCATION --encryption-services blob
    SA_KEY=$(az storage account keys list --resource-group $SA_RESOURCE_GROUP --account-name $SA_NAME --query '[0].value' -o tsv)
    
    echo "Creating Storage Container " $SA_CONTAINER_NAME
    az storage container create --name $SA_CONTAINER_NAME --account-name $SA_NAME --account-key $SA_KEY
  fi
  echo "Setting the SA_KEY value in the pipeline variable"
  echo "##vso[task.setvariable variable=ENV_STORAGE_KEY]$SA_KEY"

else
  echo "Parameter file missing, exiting.."
  exit 1
fi