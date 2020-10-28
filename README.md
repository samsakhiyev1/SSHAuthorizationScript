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
```
Enter github email : samat.sakhiyev@gmail.com
Using email samat.sakhiyev@gmail.com
Generating public/private rsa key pair.
Enter file in which to save the key (/home/sam1/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/sam1/.ssh/id_rsa
Your public key has been saved in /home/sam1/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:XQaU2cwnDhXY/GHUSbwMFCBvHSYtMxw+cgHXQbZCoxY samat.sakhiyev@gmail.com
The key's randomart image is:
+---[RSA 4096]----+
|         E=^X@*o.|
|          &*#+*o.|
|         + X*Bo..|
|        ..+o+ .o |
|        S .      |
|                 |
|                 |
|                 |
|                 |
+----[SHA256]-----+
Could not open a connection to your authentication agent.
Enter github username: samsakhiyev1
Using username samsakhiyev1
Enter github password for user samsakhiyev1: {
  "id": 46937717,
  "key": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCrIXyWaQRVaDjHUGDnZSYQ2xz+cAXGsGYp5YMb9q7nIifi9gImkw/EnIoxhfoqAbpg0x8/YD421BQfOGmVBDUY0pT/AcrWToMcZtXGhsVKTz3qReiUtIc3eEJ3/R2bxuHPIxixJta1VdX0YyLx/j63i7fvqOv6WVSAmF/FBJTBzSJsWe040Lb+vzGl7N//jQd/WAduQoPCjajHO6aUJbPWepN0tRM55+yqI0BrAP6Tr5ynlSTQ90QrmJ0fm5XhYnX43DDikHRkx1qQPRD1xoPQgcTx394USS43a6YSphYlkU5TR68EqELuQ+lwCX1Ovuk4eeuvTE7McdmiHbJkwHrvStss2JTPnizZ6C3Wy4xe7m7LUNY5jlSbIfpiICYVP7NWE75/FIvJOmw/YMeBt/UmTo0bQp+8I+Kqo8oHethspgoHN8QPY+PkW0+qzAysALA4diJS5486U8n1XTZQu9R6LSguR9PaHznXlzsG1dIx6fjhdrmK/alGCs9/4SVh26vIOC+GIZYoN3eCWoMC1LuXgKcrT14KxQoqHDDZdD0GDsid/EVt8NUmX/xtil++838oGq9bh3F5MPTYUAmOhikApfx4Xnw5GfRkznuGLIXm7ZqWygy6NhdEnczHp212GWdooAWXM0czfwxZcM9SW0GX5YCo7GZavIQeWyykStS2Gw==",
  "url": "https://api.github.com/user/keys/46937717",
  "title": "sam1-VirtualBox",
  "verified": true,
  "created_at": "2020-10-13T10:02:25Z",
  "read_only": false
}

```

4. In your GitHub settings you will be able to see new public key (GitHub account -> Settings -> SSH and GPG keys). 
5. Test SSH connection and authenticate: 
```
ssh -T git@github.com
```
In results should be something like this: 
```
Hi samsakhiyev1! You've successfully authenticated, but GitHub does not provide shell access.
```
6. Then, you will be able to clone and/or push your repository. Example: 
```
git clone git@github.com:samsakhiyev1/TestRepository.git
```
```
Cloning into 'TestRepository'...
remote: Enumerating objects: 3, done.
remote: Counting objects: 100% (3/3), done.
remote: Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
Receiving objects: 100% (3/3), done.

```
7. After authenticaion, cloning or pushing, you will see the status of your public SSH key in GitHub settings as active and the last time used. 
