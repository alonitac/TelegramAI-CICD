#!/bin/bash
(
curl -o ecr-creds-helper.yaml https://raw.githubusercontent.com/alonitac/DevOpsMay22/main/cicd_ex_helpers/ecr-creds-helper.yaml
chmod 777 ecr-creds-helper.yaml
curl https://raw.githubusercontent.com/alonitac/DevOpsMay22/main/cicd_ex_helpers/init.sh -o init.sh
chmod 777 init.sh
kubectl create namespace dev
kubectl create namespace prod

) 2>&1 | sudo tee -a full_log.log