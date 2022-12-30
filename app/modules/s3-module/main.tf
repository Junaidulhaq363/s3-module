# data "aws_canonical_user_id" "current_user" {}
# resource "aws_kms_key" "mykey" {
#   description             = "This key is used to encrypt bucket objects"
#   deletion_window_in_days = 10
# }

resource "aws_s3_bucket" "s3_bucket" {
  bucket        = var.bucket
  bucket_prefix = var.bucket_prefix
  tags          = var.tags
  acl           = var.acl
  force_destroy = var.force_destroy
  # acceleration_status = var.acceleration_status
  # bucket_domain_name  = var.bucket_domain_name
  # bucket_regional_domain_name = var.bucket_regional_domain_name
  hosted_zone_id   = var.hosted_zone_id
  request_payer    = var.request_payer
  website_domain   = var.website_domain
  website_endpoint = var.website_endpoint

  dynamic "versioning" {
    for_each = var.versioning_inputs == null ? [] : var.versioning_inputs

    content {
      enabled    = versioning.value.enabled
      mfa_delete = versioning.value.mfa_delete
    }
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rule_inputs == null ? [] : var.lifecycle_rule_inputs

    content {
      id                                     = lifecycle_rule.value.id
      prefix                                 = lifecycle_rule.value.prefix
      tags                                   = lifecycle_rule.value.tags
      enabled                                = lifecycle_rule.value.enabled
      abort_incomplete_multipart_upload_days = lifecycle_rule.value.abort_incomplete_multipart_upload_days

      dynamic "expiration" {
        for_each = lifecycle_rule.value.expiration_inputs == null ? [] : lifecycle_rule.value.expiration_inputs

        content {
          date                         = expiration.value.date
          days                         = expiration.value.days
          expired_object_delete_marker = expiration.value.expired_object_delete_marker
        }
      }

      dynamic "transition" {
        for_each = lifecycle_rule.value.transition_inputs == null ? [] : lifecycle_rule.value.transition_inputs

        content {
          date          = transition.value.date
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = lifecycle_rule.value.noncurrent_version_transition_inputs == null ? [] : lifecycle_rule.value.noncurrent_version_transition_inputs

        content {
          days          = noncurrent_version_transition.value.days
          storage_class = noncurrent_version_transition.value.storage_class
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = lifecycle_rule.value.noncurrent_version_expiration_inputs == null ? [] : lifecycle_rule.value.noncurrent_version_expiration_inputs

        content {
          days = noncurrent_version_expiration.value.days
        }
      }
    }
  }

  dynamic "cors_rule" {
    for_each = try(jsondecode(var.cors_rule), var.cors_rule)

    content {
      # allowed_methods = lookup(cors_rule.value,"allowed_methods",null)
      # allowed_origins = lookup(cors_rule.value,"allowed_origins",null)
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      allowed_headers = lookup(cors_rule.value, "allowed_headers", null)
      expose_headers  = lookup(cors_rule.value, "expose_headers", null)
      max_age_seconds = lookup(cors_rule.value, "max_age_seconds", null)
    }
  }

  dynamic "website" {
    for_each = length(keys(var.website)) == 0 ? [] : [var.website]

    content {
      index_document           = lookup(website.value, "index_document", null)
      error_document           = lookup(website.value, "error_document", null)
      redirect_all_requests_to = lookup(website.value, "redirect_all_requests_to", null)
      routing_rules            = lookup(website.value, "routing_rules", null)
    }
  }

  dynamic "grant" {
    for_each = try(jsondecode(var.grant), var.grant)
    content {
      id          = lookup(grant.value, "id", null)
      type        = grant.value.type
      permissions = grant.value.permissions
      uri         = lookup(grant.value, "uri", null)
    }
  }

  server_side_encryption_configuration {
    rule {
      bucket_key_enabled = var.bucket_key_enabled
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.kms_master_key_id
        sse_algorithm     = var.sse_algorithm
      }
    }
  }

}

resource "aws_s3_bucket_policy" "s3_bucket" {
  # count  = var.create_bucket && local.attach_policy ? 1 : 0 
  bucket = aws_s3_bucket.s3_bucket.id
  # policy = data.aws_iam_policy_document.combined[0].json
  policy = var.aws_iam_policy_document
}

# data "aws_iam_policy_document" "combined" {
#   count = var.create_bucket && local.attach_policy ? 1 : 0

#   source_policy_documents = compact([
#     var.attach_elb_log_delivery_policy ? data.aws_iam_policy_document.elb_log_delivery[0].json : "",
#     var.attach_lb_log_delivery_policy ? data.aws_iam_policy_document.lb_log_delivery[0].json : "",
#     var.attach_deny_insecure_transport_policy ? data.aws_iam_policy_document.deny_insecure_transport[0].json : "",
#     var.attach_policy ? var.policy : ""
#   ])
# }
