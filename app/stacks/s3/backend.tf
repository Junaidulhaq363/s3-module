terraform {
  backend "s3" {
    bucket         = "<%= expansion('terraform-state-:ACCOUNT-:REGION') %>"
    key            = "<%= expansion(':PROJECT/:REGION/:APP/:ROLE/:ENV/:EXTRA/:BUILD_DIR/terraform.tfstate') %>"
    region         = "<%= expansion(':REGION') %>"
    encrypt        = true
    dynamodb_table = "<%= expansion('terraform-lock-:ACCOUNT-:REGION') %>"
  }
}