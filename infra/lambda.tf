resource "aws_lambda_function" "lambda_api_crud" {
  function_name = "lambda-api-crud"
  filename      = "../server/index.zip"
  role          = aws_iam_role.role_dynamo_access.arn
  handler       = "index.handler"
  runtime       = "nodejs16.x"

  memory_size = 128
  timeout     = 5
}

resource "aws_lambda_function_url" "lambda_api_crud_url" {
  function_name      = aws_lambda_function.lambda_api_crud.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = ["https://www.haryelifsp.tk"]
    allow_methods     = ["POST"]
    allow_headers     = ["Content-Type"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}
