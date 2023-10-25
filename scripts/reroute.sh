#!/bin/sh

terraform init


if [ $(cat env_info/current_env.txt) == "blue" ]; then
  export TF_VAR_blue_ami=$(cat env_info/current_ami.txt)
  export TF_VAR_green_ami=$(cat env_info/new_ami.txt)
  if [ $TF_VAR_traffic_distribution == "split" ]; then
    terraform apply  -var-file=terraform.tfvars --auto-approve
    echo "INFO: Traffic distribution level is 50/50"
  else
    export TF_VAR_traffic_distribution="green"
    terraform apply  -var-file=terraform.tfvars --auto-approve
    echo "INFO: The traffic is routed to green env. Application running with AMI ID: $(cat env_info/new_ami.txt)"
  fi
elif [ $(cat env_info/current_env.txt) == "green" ]; then
  export TF_VAR_blue_ami=$(cat env_info/new_ami.txt)
  export TF_VAR_green_ami=$(cat env_info/current_ami.txt)
  if [ $TF_VAR_traffic_distribution == "split" ]; then
    terraform apply  -var-file=terraform.tfvars --auto-approve
    echo "INFO: Traffic distribution level is 50/50"
  else
    export TF_VAR_traffic_distribution="blue"
    terraform apply  -var-file=terraform.tfvars --auto-approve
    echo "INFO: The traffic is routed to blue env. Application running with AMI ID: $(cat env_info/new_ami.txt)"
  fi
fi