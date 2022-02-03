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
}