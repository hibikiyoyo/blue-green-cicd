#!/bin/bash
sudo nohup java -jar /home/ec2-user/my-spring-boot-app-1.0.0.jar > /dev/null 2>&1 &
sudo whoami > /tmp/log.txt
sudo pwd > /tmp/log2.txt