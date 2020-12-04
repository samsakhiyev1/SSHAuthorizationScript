# SSHAuthorizationScript

Here's a shell based script which automatically creates SSH pair of keys for authentication to GitHub repository and pastes public key in GitHub account settings . (All executions and actions were taken in Linux Ubuntu test environment and using test account of GitHub)

NOTE: given script works for Github accounts without two-factor authenticaion. Additional information about SSH authentication through GitHub can be found here: https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/connecting-to-github-with-ssh

# Guide: 

0. Install `git` in your local machine:
```
sudo apt-get install git 
```

1. Clone or copy script `git-add-key.sh`

```bash
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

```
2. Save this script and run:
```
./git-add-key.sh
```
3. Here you will need to type your github email, passphrase for the file with keys (optional), GitHub username and its password. During these, the system will generate pair of keys and copy the public key into your GitHub account for the SSH authentication.  


4. In your GitHub settings you will be able to see new public key (GitHub account -> Settings -> SSH and GPG keys). 
5. Test SSH connection and authenticate: 
```
ssh -T git@github.com
```
In results should be something like this: 
```
Hi <username>! You've successfully authenticated, but GitHub does not provide shell access.
```
6. Then, you will be able to clone and/or push your repository. Example: 
```
git clone git@github.com:<username>/<repository>.git
```
```
Cloning into '<repository>'...
remote: Enumerating objects: 3, done.
remote: Counting objects: 100% (3/3), done.
remote: Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
Receiving objects: 100% (3/3), done.

```
7. After authenticaion, cloning or pushing, you will see the status of your public SSH key in GitHub settings as active and the last time used. 
