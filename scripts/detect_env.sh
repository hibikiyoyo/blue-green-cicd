#!/bin/sh

echo "Install AWS CLI"
apk update && apk add python3 py3-pip && pip3 install --upgrade pip
pip3 install awscli
aws --version

terraform init
blue_capacity=$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names blue-asg --query 'AutoScalingGroups[0].DesiredCapacity')
green_capacity=$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names green-asg --query 'AutoScalingGroups[0].DesiredCapacity')
current_blue_lt=$(terraform output -raw blue_lt)
current_green_lt=$(terraform output -raw green_lt)
current_blue_ami=$(aws ec2 describe-launch-template-versions --launch-template-id $current_blue_lt --query 'LaunchTemplateVersions[0].LaunchTemplateData.ImageId' --output text)
current_green_ami=$(aws ec2 describe-launch-template-versions --launch-template-id $current_green_lt --query 'LaunchTemplateVersions[0].LaunchTemplateData.ImageId' --output text)

echo "INFO: Number of instances in Blue ASG : $blue_capacity"
echo "INFO: Number of instances in Green ASG : $green_capacity"
mkdir env_info

if [ $blue_capacity -gt 0 ] && [ $green_capacity -eq 0 ]; then
  echo "blue" > env_info/current_env.txt
  echo "INFO: Current application is running on Blue env with AMI ID is $current_blue_ami. The new application will be deployed on Green env"
  echo "INFO: The current AMI ID : $current_blue_ami"
  echo $current_blue_ami > env_info/current_ami.txt
elif [ $green_capacity -gt 0 ] && [ $blue_capacity -eq 0 ]; then
  echo "green" > env_info/current_env.txt
  echo "INFO: Current application is running on Green env with AMI ID is $current_green_ami. The new application will be deployed on Blue env"
  echo "INFO: The current AMI ID : $current_green_ami"
  echo $current_green_ami > env_info/current_ami.txt
elif [ $blue_capacity -eq 0 ] && [ $green_capacity -eq 0 ]; then
  echo "ERROR: No application running. Double check"
  exit 1
else
  echo "ERROR: Application already ran on both env. Double check"
  exit 1
fi

if [ -n "$UP_STREAM_AMI" ]; then
  echo $UP_STREAM_AMI > env_info/new_ami.txt
  echo "INFO: The new AMI ID for the deployment : $(cat env_info/new_ami.txt)"
elif [ -n "$CUSTOM_AMI" ]; then
  echo "INFO: Use Custom AMI ID: $CUSTOM_AMI"
else
  echo "INFO: Not found new AMI ID from upstream pipeline. Use current AMI ID: $(cat env_info/current_ami.txt)"
  echo $(cat env_info/current_ami.txt) > env_info/new_ami.txt
fi