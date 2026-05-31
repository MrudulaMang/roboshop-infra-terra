terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"  # Terrform AWS provider version
          }
  }

backend "s3" {
  bucket = "terra-state-88s-dev"
  key = "roboshop-dev-sg" # can give any keyname and extension
  region = "us-east-1"
  encrypt = true
  use_lockfile = true # 43:00 for locking state file while applying, previous version used to create dynamo db table for native locking now noneed
} 
}


# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}



