terraform {
  required_version = ">= 1.0" 
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      version = "~> 4.0.0"
      source = "hashicorp/tls"
    }
  }
}