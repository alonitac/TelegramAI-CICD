#!/bin/bash
git config --global user.name "Jenkis"
git config --global user.email "Jenkins@example.com"
git config --global --add safe.directory $4
git config remote.origin.url $5
git stash push
git checkout $2
git pull origin $2 
git stash apply
git add $1
git status
git commit -m "$3"
git status
git push origin $2