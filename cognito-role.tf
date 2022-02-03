data "aws_iam_policy_document" "authenticated" {
  statement {
    sid = "CognitoAuthenticatedUserRole"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cognito-identity.amazonaws.com"]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "cognito-identity.amazonaws.com:aud"
      values = [
        aws_cognito_identity_pool.idp.id
      ]
    }
    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:amr"
      values = [
        "authenticated"
      ]
    }
  }
}

resource "aws_iam_role" "authenticated" {
  name = "${var.cognito_name}-authenticated-role"
  assume_role_policy = data.aws_iam_policy_document.authenticated.json

  tags = {
    AssetID = var.asset_id
    ControlledBy = "Terraform"
  }
}