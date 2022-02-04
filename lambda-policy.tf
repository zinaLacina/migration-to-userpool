data "aws_iam_policy_document" "lambda_policy" {
  statement {
    sid = "congitoacess"
    actions = [
      "cognito-idp:*"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid = "logging"
    actions = [
      "logs:*"
    ]
    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }

  statement {
    sid = "enablexray"
    actions = [
      "xray:*"
    ]
    resources = [
      "*"
    ]
  }
}