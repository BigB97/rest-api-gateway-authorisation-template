resource "aws_api_gateway_account" "name" {
  cloudwatch_role_arn = aws_iam_role.name.arn
}

# Path: MAIN/rest-gateway-api.tf
resource "aws_api_gateway_rest_api" "name" {
  name        = "name"
  description = "description"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# Path: MAIN/rest-gateway-api.tf
resource "aws_api_gateway_resource" "name" {
  rest_api_id = aws_api_gateway_rest_api.name.id
  parent_id   = aws_api_gateway_rest_api.name.root_resource_id
  path_part   = "name"
}

# Path: MAIN/rest-gateway-api.tf
resource "aws_api_gateway_method" "name" {
  rest_api_id   = aws_api_gateway_rest_api.name.id
  resource_id   = aws_api_gateway_resource.name.id
  http_method   = "GET"
  authorization = "AWS_IAM"
}

# method response
resource "aws_api_gateway_method_response" "name" {
  rest_api_id = aws_api_gateway_rest_api.name.id
  resource_id = aws_api_gateway_resource.name.id
  http_method = aws_api_gateway_method.name.http_method
  status_code = 200
  response_models = {
    "application/json" = aws_api_gateway_model.name.name
  }
}

resource "aws_api_gateway_integration" "name" {
  rest_api_id             = aws_api_gateway_rest_api.name.id
  resource_id             = aws_api_gateway_resource.name.id
  http_method             = aws_api_gateway_method.name.http_method
  type                    = "AWS"
  integration_http_method = "POST"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/${aws_lambda_function.name.arn}/invocations"
  request_templates = {
    "application/json" = <<EOF
    {
      "username":"$input.params('username')",
      "password":"$util.escapeJavaScript($input.params('password')).replaceAll("\\'","'")",
      "serverId":"$input.params('serverId')",
    }
    EOF
  }
  request_parameters = {
    "integration.request.header.password" = "method.request.querystring.password"

}

resource "aws_api_gateway_model" "name" {
  rest_api_id  = aws_api_gateway_rest_api.name.id
  name         = "name"
  content_type = "application/json"
  schema       =  jsonencode({
    type = "object"
    properties = {
      username = {
        type = "string"
      }
      password = {
        type = "string"
      }
      serverId = {
        type = "string"
      }
    }
  })

}
