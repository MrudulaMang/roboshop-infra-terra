terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 6.0"
      }
    }
} 

backend "s3" {
  name = "terra-state-88s-dev"
  key = "roboshop-dev-mongodb" 
  region = "us-east-1a"
  encrypt = true
  use_lockfile = true 
}

provider "aws" {
  region = "us-east-1a"
}

