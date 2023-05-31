#!/bin/bash
sudo yum update -y 
sudo yum install docker -y 
sudo yum install git -y 
sudo yum install libicu -y
mkdir actions-runner && cd actions-runner# Download the latest runner package
curl -o actions-runner-linux-x64-2.304.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.304.0/actions-runner-linux-x64-2.304.0.tar.gz
echo "292e8770bdeafca135c2c06cd5426f9dda49a775568f45fcc25cc2b576afc12f  actions-runner-linux-x64-2.304.0.tar.gz" | shasum -a 256 -c
tar xzf ./actions-runner-linux-x64-2.304.0.tar.gz
sudo systemctl enable docker