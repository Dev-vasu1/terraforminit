terraform {
  backend "s3" {
    bucket = "mybackendterra-121"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}