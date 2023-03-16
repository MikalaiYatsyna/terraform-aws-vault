resource "aws_dynamodb_table" "vault-backend" {
  name         = "${var.stack}-${local.app_name}-data"
  hash_key     = "Path"
  range_key    = "Key"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "Path"
    type = "S"
  }

  attribute {
    name = "Key"
    type = "S"
  }
}
