# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

identity_token "aws" {
  audience = ["aws.workload.identity"]
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

orchestrate "auto_approve" "safe_plans_dev" {
  check {
      # Only auto-approve in the development environment if no resources are being removed
      condition = context.plan.changes.remove == 0 && context.plan.deployment == deployment.development
      reason = "Plan has ${context.plan.changes.remove} resources to be removed."
  }
}
