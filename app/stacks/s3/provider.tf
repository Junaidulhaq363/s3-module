terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.46.0" #4.46.0
    }
  }
}


provider "aws" {
  # The security credentials for AWS Account A.
  # region   = "us-east-1"

  region="us-west-2"

}