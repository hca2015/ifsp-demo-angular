locals {
  path = "/Users/haryelca/.aws/credentials"
}

provider "aws" {
  region                   = "sa-east-1"
  shared_credentials_files = [local.path]
  alias                    = "main"
}

provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = [local.path]
  alias                    = "useast1"
}
