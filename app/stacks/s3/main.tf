# This is where you put your resource declaration
# data "aws_canonical_user_id" "current" {}

module "s3-bucket" {
  #imp
  source           = "./modules/s3-module/"
  bucket           = "apidoc-tatasky"
  hosted_zone_id   = "Z11RGJOFQNVJUP"
  request_payer    = "BucketOwner"
  website_domain   = "s3-website.ap-south-1.amazonaws.com"
  website_endpoint = "apidoc-tatasky.s3-website.ap-south-1.amazonaws.com"
  versioning_inputs = [
    {
      enabled    = false
      mfa_delete = false
    }
  ]

  website = {
    index_document = "index.html"
  }
  bucket_key_enabled = false
  sse_algorithm      = "AES256"
}
# curl -k https://registry.terraform.io/.well-known/terraform.json
