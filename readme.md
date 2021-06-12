Enter the details in format. <RG-Name>:<Location>

# Commands to Us
terraform init -backend-config="backend.tfvars"
terraform plan -var-file="variables.tfvars"
terraform apply -var-file="variables.tfvars" -auto-approve