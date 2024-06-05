# AWS IAM User with Policy

This is a fairly simple module that just creates a IAM user with accesskey, secret access key and attaching custom or managed IAM policies to the same IAM user.

## Usage

This module assumes, you creating IAM user with policy attached. It can be used for authenticating and allowing access to aws resources.

```bash
locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract out common variables for reuse
  app_environment = lower(local.environment_vars.locals.app_environment)
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git::ssh://git@bitbucket.deluxe.com:7999/dtf/aws-iam-user-with-policy//?ref=1.0.0"
}

dependency "common-tags" {
  config_path = "${get_terragrunt_dir()}/../common-tags"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  create_user = true
  create_iam_user_login_profile = false
  create_iam_access_key = true
  name = "${local.app_environment}-database-backup"
  create_policy = true
  policy_name = "${local.app_environment}-database-backup-user-policy"
  policy_statement = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "kms:CreateAlias",
                "kms:CreateKey",
                "kms:DeleteAlias",
                "kms:Describe*",
                "kms:GenerateRandom",
                "kms:GenerateDataKey",
                "kms:Get*",
                "kms:List*",
                "kms:TagResource",
                "kms:UntagResource",
                "iam:ListGroups",
                "iam:ListRoles",
                "iam:ListUsers"
            ],
            "Resource": "*"
        }
    ]
}
EOF
  tags = merge({ "TerraformPath" = path_relative_to_include() }, dependency.common-tags.outputs.common_tags)
}
```

## Input Variables

| Variable Name | Description | Default Value | Usage Notes |
|--|--|--|--|
| create_user | Determines whether to create IAM user or not. | true | This will opt is to create IAM user |
| create_iam_user_login_profile | Determines whether to create IAM user login profile | true | This will opt is to create IAM user login profile |
| create_iam_access_key | Determines whether to create IAM access key | true | This will opt is to create IAM accesskey, secrey access key |
| name | Desired name for the IAM user | null | This is name of the IAM user |
| path | Desired path for the IAM user | / | This is path of IAM user |
| force_destroy | When destroying this user, destroy even if it has non-Terraform-managed IAM access keys, login profile or MFA devices. Without force_destroy a user with non-Terraform-managed access keys and login profile will fail to be destroyed | false | This will be used for force deleting of IAM user |
| pgp_key | Either a base-64 encoded PGP public key, or a keybase username in the form `keybase:username`. Used to encrypt password and access key | null | This will be used to encrypt password and access key |
| password_reset_required | Whether the user should be forced to reset the generated password on first login | true | This will used for reset password at user login |
| password_length | The length of the generated password | 20 | This is max allowed password length |
| upload_iam_user_ssh_key | Determines whether to upload a public ssh key to the IAM user | false | This will be used for enable ssh key authentication |
| ssh_key_encoding | Specifies the public key encoding format to use in the response. To retrieve the public key in ssh-rsa format, use SSH. To retrieve the public key in PEM format, use PEM | SSH | This is used for specifying the format for retrieving pubic key in ssh format |
| ssh_public_key | The SSH public key. The public key must be encoded in ssh-rsa format or PEM format | null | This is ssh pulbic key content |
| permissions_boundary | The ARN of the policy that is used to set the permissions boundary for the user | null | This will be used to set permission boundary of user |
| create_policy | Determines whether to create IAM Policy | false | This will opt is to create IAM user policy |
| policy_name | Desired name of the IAM Policy | null | This is name of the IAM user policy |
| policy_statement | Contents of policy statement | null | The policy document in json format |
| attach_managed_policy | Determines whether to attach existing IAM Policies | false | This will be used to attach aws managed IAM policies |
| managed_policy_arns | List of IAM Policies to be attached | [] | The list of policy arns to be attached |
| tags | A map of tags to add to IAM role resources | {} | The list of tags will be created for IAM user |
---
