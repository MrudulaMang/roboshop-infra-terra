#!/bin/bash
#session -40 - 41:00
# we ar creating 50gb root volume only 20 gb is partioned, 
# remaining 30gb is extended using below commands
growpart /dev/nvme0n1 4 #grow full size
pvresize /dev/nvme0n1p4 #i wrote coz lvextend may fail
lvextend -r -L +30G /dev/mapper/RootVG-homeVol
# xfx_growfs /home ----no need to use this command when using -r in the above

#installing terraform inbastian to execute terra cmds to run ansible playbook in mongo thru terra to install mongodb database
yum install -y yum-utils 
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
yum -y install terraform





# This script is preparing the Bastion server and then using it to create infrastructure.

# Summary:

# Storage Expansion
# Extends the disk partition.
# Increases the logical volume size by 30 GB.
# Expands the /home filesystem so the operating system can use the additional space.
# Terraform Installation
# Installs required package management utilities.
# Adds the HashiCorp repository.
# Installs Terraform on the Bastion server.
# Database Infrastructure Deployment
# Downloads the infrastructure code repository.
# Sets ownership so the EC2 user can manage the files.
# # Moves to the database Terraform directory.
# # Initializes Terraform.
# # Creates all database-related AWS resources automatically.
# # Application Components Deployment
# # Downloads the same infrastructure repository.
# # Sets proper file ownership.
# # Moves to the components Terraform directory.
# # Initializes Terraform.
# # Creates all application component infrastructure automatically.

# Overall flow:

# Bastion boots → Expand storage → Install Terraform → Download Infrastructure Code → Create Databases → Create Application Components

# This explains why the Bastion needs AWS permissions. The script is not merely acting as a jump server; it is executing Terraform commands that create AWS resources. When Terraform runs, it must authenticate to AWS, and it does that using the IAM role attached to the Bastion instance. Without sufficient permissions, the terraform apply commands would fail.



riverside - 55000
usd       - 45000