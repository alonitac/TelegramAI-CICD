#!/bin/bash
git config --global user.name "Jenkis"
git config --global user.email "Jenkins@example.com"
echo "Running git stash push"
git stash push
echo "Running git checkout $2"
git checkout $2
echo "Running git pull $2"
git pull origin $2 
echo "Running git stash apply"
git stash apply
echo "git add $1"
git add $1
echo "git status"
git status
echo "git commit -m $3"
git commit -m "$3"
echo "git status"
git status
echo "git push origin $2"
git push origin $2