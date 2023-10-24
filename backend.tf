terraform {
  backend "s3" {
    bucket         = "poc-tfstate-jason"
    key            = "poc_state_key/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "poc-state-lock-jason"
  }
}