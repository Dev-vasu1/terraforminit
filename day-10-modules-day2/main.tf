module "s3_bucket" {
    source = "github.com/Dev-vasu1/terraform-aws-s3-bucket.git"
  bucket = var.bucket
  acl    = var.acl

  control_object_ownership = var.control_object_ownership
  object_ownership         = var.object_ownership

  versioning = {
    enabled = var.versioning["enabled"]
  }
}