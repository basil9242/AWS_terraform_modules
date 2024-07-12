terraform {
  required_version = ">= 1.0" 
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    pgp = {
      source = "ekristen/pgp"
      version = "~>0.2.4"
    }
  }
}