variable "bucket_prefix" {
  type        = string
  description = "(required if not using 'bucket') Creates a unique bucket name beginning with the specified prefix. Conflicts with bucket."
  default     = null
}

variable "bucket" {
  type        = string
  description = "(Optional) Name of the Bucket"
  default     = null
}

variable "acl" {
  type        = string
  description = "(Optional) The canned ACL to apply. Defaults to private. Conflicts with grant."
  default     = null
}

variable "versioning" {
  type        = bool
  description = "(Optional) A state of versioning."
  default     = false
}

variable "target_bucket" {
  type        = string
  description = "(Required) The name of the bucket that will receive the log objects."
  default     = ""
}

variable "target_prefix" {
  type        = string
  description = "(Optional) To specify a key prefix for log objects."
  default     = "log/"
}

variable "kms_master_key_id" {
  type        = string
  description = "(optional) The AWS KMS master key ID used for the SSE-KMS encryption. This can only be used when you set the value of sse_algorithm as aws:kms. The default aws/s3 AWS KMS master key is used if this element is absent while the sse_algorithm is aws:kms."
  default     = ""
}

variable "sse_algorithm" {
  type        = string
  description = "(required) The server-side encryption algorithm to use. Valid values are AES256 and aws:kms"
  default     = ""
}

variable "bucket_domain_name" {
  type        = string
  description = "The bucket domain name. Will be of format bucketname.s3.amazonaws.com"
  default     = null
}
variable "bucket_regional_domain_name" {
  type        = string
  description = "The bucket region-specific domain name."
  default     = null
}
variable "hosted_zone_id" {
  type        = string
  description = "The Route 53 Hosted Zone ID for this bucket's region."
  default     = null
}
variable "region" {
  type        = string
  description = "The AWS region this bucket resides in."
  default     = null
}

variable "cors_rule" {
  description = "List of maps containing rules for Cross-Origin Resource Sharing."
  type        = any
  default     = []
}

variable "grant" {
  description = "An ACL policy grant. Conflicts with acl."
  type        = any
  default     = []
}

variable "website" {
  description = "Map containing static web-site hosting or redirect configuration."
  type        = any
  default     = {}
}

variable "website_domain" {
  type        = string
  description = "The domain of the website endpoint, if the bucket is configured with a website. If not, this will be an empty string. This is used to create Route 53 alias records."
  default     = null
}

variable "request_payer" {
  type        = string
  description = "(Optional) Specifies who should bear the cost of Amazon S3 data transfer. Can be either BucketOwner or Requester(Optional) Specifies who should bear the cost of Amazon S3 data transfer. Can be either BucketOwner or Requester"
  default     = null
}
variable "website_endpoint" {
  type        = string
  description = "The website endpoint, if the bucket is configured with a website. If not, this will be an empty string."
  default     = null
}

variable "tags" {
  type        = map(any)
  description = "(Optional) A mapping of tags to assign to the bucket."
  default     = null
}

variable "force_destroy" {
  description = "(Optional, Default:false ) A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  type        = bool
  default     = null
}
variable "acceleration_status" {
  description = "(Optional) Sets the accelerate configuration of an existing bucket. Can be Enabled or Suspended."
  type        = string
  default     = ""
}

variable "versioning_inputs" {
  type = list(object({
    enabled    = string
    mfa_delete = string
  }))
  default = null
}

variable "bucket_key_enabled" {
  description = "(Optional) Whether or not to use Amazon S3 Bucket Keys for SSE-KMS."
  type        = string
  default     = null
}
variable "lifecycle_rule_inputs" {
  type = list(object({
    id                                     = string
    prefix                                 = string
    tags                                   = map(string)
    enabled                                = string
    abort_incomplete_multipart_upload_days = string
    expiration_inputs = list(object({
      date                         = string
      days                         = number
      expired_object_delete_marker = string
    }))
    transition_inputs = list(object({
      date          = string
      days          = number
      storage_class = string
    }))
    noncurrent_version_transition_inputs = list(object({
      days          = number
      storage_class = string
    }))
    noncurrent_version_expiration_inputs = list(object({
      days = number
    }))
  }))
  default = null
}

variable "server_side_encryption_configuration_inputs" {
  type = list(object({
    sse_algorithm     = string
    kms_master_key_id = string
  }))
  default = null
}
variable "aws_iam_policy_document" {
  type        = string
  default     = ""
  description = "Specifies the number of days after object creation when the object expires."
}
