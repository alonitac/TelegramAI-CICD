#!/bin/bash
git stash push
git checkout $2
git config --global user.email "Jenkins@example.com"
git config --global user.name "Jenkis"
git pull origin $2 
git stash apply
git add "$1"
git status
git commit -m "$3"
git status
git push origin $2