output "Cognito-PoolID" {
  value = aws_cognito_user_pool.pool.id
}

output "Cognito-Domain" {
  value = aws_cognito_user_pool.pool.domain
}
