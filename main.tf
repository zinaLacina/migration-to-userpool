provider "aws" {
  region = "us-east-1"
  profile = "monbili"
}

terraform {
  backend "s3" {
    bucket = "tf.infra.monbili.state"
    dynamodb_table = "tf-infra-monbili-state"
    encrypt = true
    key = "migration/cognito/terraform.tfstate"
    region = "us-east-1"
  }
}