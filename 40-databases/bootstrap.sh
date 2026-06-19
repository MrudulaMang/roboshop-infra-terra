#!/bin/bash
component=$1
environment=$2
app_version=$3
dnf install ansible -y
cd /home/ec2-user
rm -rf ansible-roboshop-roles-tf 
  #Because -f tells Linux:“Even if file/dir doesn’t exist, don’t complain”
git clone https://github.com/MrudulaMang/ansible-roboshop-roles-tf.git
cd ansible-roboshop-roles-tf
#git pull
ansible-playbook -e component=$component -e env=$environment app_version=$app_version roboshop.yaml
sudo chown -R ec2-user:ec2-user /home/ec2-user/roboshop-infra-terra


# if [ -d "repo" ]; then
#   cd repo && git pull
# else
#   git clone repo-url
# fi

# Checks actual git repo, not just folder
# Avoids broken cases like:
#folder exists but not a git repo
