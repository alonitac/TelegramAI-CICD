#!/bin/bash
(
su ec2-user -c 'curl -o /home/ec2-user/ecr-creds-helper.yaml https://raw.githubusercontent.com/alonitac/DevOpsMay22/main/cicd_ex_helpers/ecr-creds-helper.yaml'
chmod 777 /home/ec2-user/ecr-creds-helper.yaml
su ec2-user -c 'curl https://raw.githubusercontent.com/TamirNator/TelegramAI-CICD/main/deploy/terragrunt/tfscripts/init.sh -o /home/ec2-user/init.sh'
chmod 777 /home/ec2-user/init.sh
sudo su - ec2-user /home/ec2-user/init.sh
su ec2-user -c 'kubctl create namespace dev'
su ec2-user -c 'kubctl create namespace prod'

) 2>&1 | sudo tee -a /home/ec2-user/full_log.log