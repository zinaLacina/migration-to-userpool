resource "aws_cognito_user_group" "groups" {
  for_each = var.groups

  name         = each.value
  user_pool_id = aws_cognito_user_pool.pool.id
  description = "All users pools group ${each.value}"
  precedence = each.key
  role_arn = aws_iam_role.authenticated.arn
}