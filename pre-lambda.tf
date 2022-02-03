
resource "aws_lambda_function" "pre_lambda" {
  function_name = var.pre_lambda_name
  runtime = var.lambda_runtime
  role          = aws_iam_role.lambda.arn
  handler = "${path.module}/lambdas/preauth/${var.lambda_handler}"
  filename = "${path.module}/lambdas/preauth.zip"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  timeout = 900
  memory_size = 128
  environment {
    variables = {
#      CognitoID = aws_cognito_user_pool.pool.id
      AssetID = var.asset_id
    }
  }
  tags = {
    AssetID = var.asset_id
  }
}

resource "null_resource" "build_step" {
  triggers = {
    handler = base64sha256(file("${path.module}/lambdas/preauth/lambda_function.py"))
    requirements = base64sha256(file("${path.module}/lambdas/preauth/requirements.txt"))
    build = base64sha256(file("${path.module}/lambdas/preauth/build.sh"))
  }

  provisioner "local-exec" {
    command  = "${path.module}/lambdas/preauth/build.sh"
  }
}
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir = "${path.module}/lambdas/preauth"
  output_path = "${path.module}/lambdas/preauth.zip"
  depends_on = [null_resource.build_step]
}

resource "aws_iam_role" "lambda" {
  name = var.pre_lambda_name
  path = "/"
  assume_role_policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
      {
        Action: "sts:AssumeRole"
        Principal: {
          Service: "lambda.amazonaws.com"
        },
        Effect: "Allow",
        Sid: ""
      }
    ]
  } )
  inline_policy {
    name = "${var.pre_lambda_name}-LambdaExecutionRole"
    policy = data.aws_iam_policy_document.lambda_policy.json
  }
}