###
# Creates the S3 bucket used for communication fo ansible and the instances when ssm agent installed
# The ansible connection is done using this module https://docs.ansible.com/ansible/latest/collections/community/aws/aws_ssm_connection.html
# This module will generate a presigned URL for S3 from the controller, and then will pass that URL to the target over SSM,
# telling the target to download/upload from S3 with curl.
###

resource "aws_s3_bucket" "ansible" {

  bucket = local.name_prefix

  tags = {
    Role = "ansible"
  }
}
