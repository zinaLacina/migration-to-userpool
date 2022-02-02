
resource "aws_cognito_user_pool" "pool" {
  name = var.cognito_name
  auto_verified_attributes = ["email", "phone"]
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

  tags = {
    "AssetID": var.asset_id
  }
}