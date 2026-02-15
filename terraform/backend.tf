terraform {
  backend "s3" {
    bucket         = "infra-reliability-lab-tfstate-413267728348"
    key            = "prod/terraform.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "infra-reliability-lock"
    encrypt        = true
  }
}
