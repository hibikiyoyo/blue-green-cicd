#!/bin/sh

terraform init


if [ $(cat env_info/current_env.txt) == "blue" ]; then
  export TF_VAR_blue_ami=$(cat env_info/current_ami.txt)
  export TF_VAR_green_ami=$(cat env_info/new_ami.txt)
  export TF_VAR_traffic_distribution="green"
  terraform apply  -var-file=green.tfvars --auto-approve
  echo "INFO: the instance of blue env ( use AMI ID $(cat env_info/current_ami.txt) )are retired"
elif [ $(cat env_info/current_env.txt) == "green" ]; then
  export TF_VAR_blue_ami=$(cat env_info/new_ami.txt)
  export TF_VAR_green_ami=$(cat env_info/current_ami.txt)
  export TF_VAR_traffic_distribution="blue"
  terraform apply -var-file=blue.tfvars --auto-approve
  echo "INFO: the instance of green env ( use AMI ID $(cat env_info/current_ami.txt) ) are retired"
fi