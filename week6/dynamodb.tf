resource "aws_dynamodb_table" "provider-table" {
  name           = var.dynamo_db_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "UserName"
  attribute {
    name = "UserName"
    type = "S"
  }
}