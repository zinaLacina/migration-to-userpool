locals {
  groups = toset([
    "admin",
    "client",
  ])
}

variable "groups" {
  type = map(string)
  default = {
    "1" = "admin-user"
    "2" = "client-user"
  }
}

variable "cognito_name" {
  default = "dev-user-pool"
  type = string
}

variable "asset_id" {
  default = "001"
  type = string
}

variable "domain" {
  default = "auth-monbili-dev"
  type = string
}

variable "client_name" {
  default = "auth-monbili-client-dev"
  type = string
}

variable "pre_lambda_name" {
  default = "monbili_pre_authentication"
}

variable "post_lambda_name" {
  default = "monbili_post_authentication"
}

variable "lambda_handler" {
  default = "lambda_function.lambda_handler"
}

variable "lambda_runtime" {
  default = "python3.9"
}

