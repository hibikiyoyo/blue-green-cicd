#!/bin/sh

terraform init

if [ $(cat env_info/current_env.txt) == "blue" ]; then
  export TF_VAR_blue_ami=$(cat env_info/current_ami.txt)
  export TF_VAR_green_ami=$(cat env_info/new_ami.txt)
  terraform plan  -var-file=terraform.tfvars -var 'traffic_distribution=blue' -out=tfplan
elif [ $(cat env_info/current_env.txt) == "green" ]; then
  export TF_VAR_blue_ami=$(cat env_info/new_ami.txt)
  export TF_VAR_green_ami=$(cat env_info/current_ami.txt)
  terraform plan  -var-file=terraform.tfvars -var 'traffic_distribution=green' -out=tfplan
fi

echo "INFO: Current application is running on $(cat env_info/env.txt) env with current AMI ID: $(cat env_info/current_ami.txt)"
echo "INFO: The new application version will be deployed with AMI ID: $(cat env_info/new_ami.txt) "