# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

identity_token "aws" {
  audience = ["<Set to your AWS IAM assume-role audience>"]
}

# A single workload token can be trusted by multiple accounts - but optionally, you can generate a
# separate token with a difference audience value for your second account and use it below.
#
# identity_token "account_2" {
#   audience = ["aws.workload.identity"]
# }

deployment "development" {
  inputs = {
    region         = "us-east-1"
    role_arn       = "arn:aws:iam::798714130597:role/stacks-hashicorp-kranthi-Demo"
    identity_token = identity_token.aws.jwt
    default_tags   = { stacks-preview-example = "lambda-multi-account-stack" }
  }
}

deployment "production" {
  inputs = {
    region         = "us-east-2"
    role_arn       = "arn:aws:iam::798714130597:role/stacks-hashicorp-kranthi-Demo"
    identity_token = identity_token.aws.jwt
    default_tags   = { stacks-preview-example = "lambda-multi-account-stack" }
  }
}

