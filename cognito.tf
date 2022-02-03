
resource "aws_cognito_user_pool" "pool" {
  name = var.cognito_name
  auto_verified_attributes = ["email"]
  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
  }

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  lambda_config {
    pre_authentication = aws_lambda_function.pre_lambda.arn
    post_authentication = aws_lambda_function.pre_lambda.arn
  }

  tags = {
    "AssetID": var.asset_id
  }
}

resource "aws_cognito_user_pool_domain" "domain" {
  domain       = var.domain
  user_pool_id = aws_cognito_user_pool.pool.id
}

resource "aws_cognito_user_pool_client" "client" {
  name         = var.client_name
  user_pool_id = aws_cognito_user_pool.pool.id
  generate_secret = false
  allowed_oauth_flows = ["code"]
  supported_identity_providers = ["COGNITO"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes = ["email", "openid"]
  explicit_auth_flows = ["USER_PASSWORD_AUTH"]
  callback_urls = ["https://www.monbili.com"]

  depends_on = [
    aws_cognito_user_pool.pool
  ]
}

resource "aws_cognito_identity_pool" "idp" {
  identity_pool_name = var.cognito_name
  allow_unauthenticated_identities = false

  cognito_identity_providers {
    client_id = aws_cognito_user_pool_client.client.id
    provider_name = "cognito-idp.us-east-1.amazonaws.com/${aws_cognito_user_pool.pool.id}"
    server_side_token_check = false
  }
}

resource "aws_cognito_identity_pool_roles_attachment" "idp_attachment" {
  identity_pool_id = aws_cognito_identity_pool.idp.id
  role_mapping {
    identity_provider = "cognito-idp.us-east-1.amazonaws.com/${aws_cognito_user_pool.pool.id}:${aws_cognito_user_pool_client.client.id}"
    type              = "Token"
    ambiguous_role_resolution = "AuthenticatedRole"
  }
  roles            = {
    "authenticated" = aws_iam_role.authenticated.arn
  }

  depends_on = [
    aws_cognito_user_pool.pool
  ]
}