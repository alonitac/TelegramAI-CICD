#!/bin/bash
(
echo "###Running: yum update"
sudo yum update -y
echo "###Running: amazon-linux-extras install epel"
sudo amazon-linux-extras install epel -y
echo "###Running: yum wget jenkings"
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
echo "###Running: rpm --import"
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
echo "###Running: yum upgrade"
sudo yum upgrade -y
echo "###Running: sudo amazon-linux-extras install java-openjdk11 -y"
sudo amazon-linux-extras install java-openjdk11 -y
echo "###Running: yum install jenkins -y"
sudo yum install jenkins -y
echo "###Running: systemctl enable jenkins"
sudo systemctl enable jenkins
echo "###Running: systemctl start jenkins"
sudo systemctl start jenkins
echo sudo systemctl status jenkins > ~/jenkins_status.log
echo installing docker
sudo yum install docker -y
sudo service docker start
sudo usermod -a -G docker jenkins
echo installing git
sudo yum install git -y
git version

) 2>&1 | sudo tee -a /home/ec2-user/full_log.log