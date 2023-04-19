#!/bin/bash
(
sudo su ec2-user
sudo curl -o /home/ec2-user/ecr-creds-helper.yaml https://raw.githubusercontent.com/alonitac/DevOpsMay22/main/cicd_ex_helpers/ecr-creds-helper.yaml
sudo chmod 777 /home/ec2-user/ecr-creds-helper.yaml
sudo curl https://raw.githubusercontent.com/alonitac/DevOpsMay22/main/cicd_ex_helpers/init.sh -o /home/ec2-user/init.sh 
cd /home/ec2-user/
su ec2-user -c 'bash -e init.sh'
sudo bash -e init.sh -u ec2-user
) 2>&1 | sudo tee -a /home/ec2-user/full_log.log