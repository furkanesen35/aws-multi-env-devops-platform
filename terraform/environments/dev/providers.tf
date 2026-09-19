terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"

  default_tags {
    tags = {
      Project     = "aws-multi-env-devops-platform"
      Environment = "dev"
      ManagedBy   = "Terraform"
    }
  }
}
