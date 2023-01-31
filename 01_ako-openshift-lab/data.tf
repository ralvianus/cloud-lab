data "aws_s3_object" "private_key" {
  bucket = "ralvianus-avi-bucket"
  key    = "secrets/aws-rsa"
}