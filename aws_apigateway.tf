#####################################
#API Gateway Settings
#####################################
resource "aws_api_gateway_rest_api" "sample" {
    name = "sample"
    description = "sample"
}

resource "aws_api_gateway_api_key" "sample" {
    name = "sample"
}

#############################################
#POST method
#############################################
resource "aws_api_gateway_model" "post-sample" {
  rest_api_id = "${aws_api_gateway_rest_api.sample.id}"
  name = "PostSample"
  description = "post-sample"
  content_type = "application/json"
  schema = <<EOF
{
  "type" : "object",
  "properties" : {
    "key": { "type": "string" }
  }
}
EOF
}

resource "aws_api_gateway_method" "post-sample" {
  rest_api_id = "${aws_api_gateway_rest_api.sample.id}"
  resource_id = "${aws_api_gateway_rest_api.sample.root_resource_id}"
  http_method = "POST"
  authorization = "NONE"
  api_key_required = "true"
  request_models = {
     "application/json" = "${aws_api_gateway_model.post-sample.name}"
  }
}

resource "aws_api_gateway_integration" "post-sample" {
  rest_api_id = "${aws_api_gateway_rest_api.sample.id}"
  resource_id = "${aws_api_gateway_rest_api.sample.root_resource_id}"
  http_method = "${aws_api_gateway_method.post-sample.http_method}"
  type = "AWS"
  uri = "arn:aws:apigateway:ap-northeast-1:dynamodb:action/PutItem"
  integration_http_method = "POST"
  credentials = "${aws_iam_role.post-sample.arn}"
  passthrough_behavior = "WHEN_NO_TEMPLATES"
  request_templates  = {
    "application/json" = "${file("request_templates/post-sample.json")}"
  }
}

resource "aws_api_gateway_integration_response" "post-sample" {
  rest_api_id = "${aws_api_gateway_rest_api.sample.id}"
  resource_id = "${aws_api_gateway_rest_api.sample.root_resource_id}"
  http_method = "${aws_api_gateway_method.post-sample.http_method}"
  status_code = "${aws_api_gateway_method_response.post-sample.status_code}"
  selection_pattern = "200"
  response_templates = {
    "application/json" = "{'message':'Success'}"
  }
}

resource "aws_api_gateway_method_response" "post-sample" {
  rest_api_id = "${aws_api_gateway_rest_api.sample.id}"
  resource_id = "${aws_api_gateway_rest_api.sample.root_resource_id}"
  http_method = "${aws_api_gateway_method.post-sample.http_method}"
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
}

#############################################
#GET method
#############################################
resource "aws_api_gateway_model" "get-sample" {
    rest_api_id = "${aws_api_gateway_rest_api.sample.id}"
    name = "GetSample"
    description = "get-sample"
    content_type = "application/json"
    schema = <<EOF
{
    "type": "array",
    "items": {
        "type": "object",
        "properties": {
            "primary_key": {
                "type": "string"
            }
        }
    }
}
EOF
}

resource "aws_api_gateway_method" "get-sample" {
    rest_api_id = "${aws_api_gateway_rest_api.sample.id}"
    resource_id = "${aws_api_gateway_rest_api.sample.root_resource_id}"
    http_method = "GET"
    authorization = "NONE"
    api_key_required = "true"
}

resource "aws_api_gateway_integration" "get-sample" {
    rest_api_id = "${aws_api_gateway_rest_api.sample.id}"
    resource_id = "${aws_api_gateway_rest_api.sample.root_resource_id}"
    http_method = "${aws_api_gateway_method.get-sample.http_method}"
    type = "AWS"
    uri = "arn:aws:apigateway:ap-northeast-1:dynamodb:action/Scan"
    integration_http_method = "POST"
    credentials = "${aws_iam_role.get-sample.arn}"
    passthrough_behavior = "WHEN_NO_TEMPLATES"
    request_templates  = {
        "application/json" = "${file("request_templates/get-sample.json")}"
    }
}

resource "aws_api_gateway_integration_response" "get-sample" {
  rest_api_id = "${aws_api_gateway_rest_api.sample.id}"
  resource_id = "${aws_api_gateway_rest_api.sample.root_resource_id}"
  http_method = "${aws_api_gateway_method.get-sample.http_method}"
  status_code = "${aws_api_gateway_method_response.get-sample.status_code}"
  selection_pattern = "200"
  response_templates = {
    "application/json" = "${file("response_templates/get-sample.json")}"
  }
}

resource "aws_api_gateway_method_response" "get-sample" {
  rest_api_id = "${aws_api_gateway_rest_api.sample.id}"
  resource_id = "${aws_api_gateway_rest_api.sample.root_resource_id}"
  http_method = "${aws_api_gateway_method.get-sample.http_method}"
  status_code = "200"
  response_models = {
    "application/json" = "${aws_api_gateway_model.get-sample.name}"
  }
}

#############################################
#API Gateway Deploy
#############################################
resource "aws_api_gateway_deployment" "sample" {
  depends_on = [
    "aws_api_gateway_method.get-sample",
    "aws_api_gateway_method.post-sample",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.sample.id}"
  stage_name = "sample"

}

#############################################
#API Gateway Plan
#############################################
resource "aws_api_gateway_usage_plan" "sample" {
  name         = "sample"
  description  = "sample"

  api_stages {
    api_id = "${aws_api_gateway_rest_api.sample.id}"
    stage  = "${aws_api_gateway_deployment.sample.stage_name}"
  }
}

resource "aws_api_gateway_usage_plan_key" "sample" {
  key_id        = "${aws_api_gateway_api_key.sample.id}"
  key_type      = "API_KEY"
  usage_plan_id = "${aws_api_gateway_usage_plan.sample.id}"
}
