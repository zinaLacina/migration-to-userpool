resource "aws_cloudwatch_log_group" "lambda_log" {
  name = "/aws/lambda/monbili_pre_authentication"
  retention_in_days = 7
  tags = {
    AssetID = var.asset_id
  }
}