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
  authorization = AWS_IAM
  integration {
    type                    = AWS
    integration_http_method = "POST"
    uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/${aws_lambda_function.name.arn}/invocations"
    integration_responses {
      status_code = 200
    }
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
      method.request.header.password = false
    }
    method_responses {
      status_code = 200
      response_models = {
        "application/json" = aws_api_gateway_model.name.name
      }
    }
  }
}


resource "aws_api_gateway_model" "name" {
  rest_api_id  = aws_api_gateway_rest_api.name.id
  name         = "name"
  content_type = "application/json"
  schema       = <<EOF
  {
  '$schema': 'http://json-schema.org/draft-04/schema#',
   title: 'name',
   type: 'object',
   properties: {
    HomeDirectory: {
      type: 'string'
    },
    Role: {
      type: 'string'
    },
    Policy: {
      type: 'string'
    },
    PublicKey: {
      type: 'array',
      items: {
        type: 'string'
      }
    },
   }
  }
  EOF

}
