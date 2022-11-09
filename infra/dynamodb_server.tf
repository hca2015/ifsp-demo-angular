resource "aws_dynamodb_table" "dynamodb-table-usuarios" {

  name           = "usuarios"
  billing_mode   = "PROVISIONED"
  read_capacity  = 10
  write_capacity = 10
  hash_key       = "UserId"  

  attribute {
    name = "UserId"
    type = "S"
  }  

  tags = {
    Name        = "dynamodb-table-usuarios"
    Environment = "production"
  }
}