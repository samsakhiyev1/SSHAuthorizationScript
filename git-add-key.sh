#!/bin/bash

rm -rf ~/.ssh/id_rsa ~/.ssh/id_rsa.pub
read -p "Enter github email : " email
echo "Using email $email"
ssh-keygen -t rsa -b 4096 -C "$email"
ssh-add ~/.ssh/id_rsa
pub=`cat ~/.ssh/id_rsa.pub`
read -p "Enter github username: " githubuser
echo "Using username $githubuser"
read -s -p "Enter github password for user $githubuser: " githubpass
curl -u "$githubuser:$githubpass" -X POST -d "{\"title\":\"`hostname`\",\"key\":\"$pub\"}" --header "x-github-otp: $otp" https://api.github.com/user/keys
