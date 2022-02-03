output "Cognito-PoolID" {
  value = aws_cognito_user_pool.pool.id
}

output "Cognito-Domain" {
  value = aws_cognito_user_pool.pool.domain
}

output "App-client-ID" {
  value = aws_cognito_user_pool_client.client.id
}
