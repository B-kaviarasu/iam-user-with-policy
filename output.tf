# IAM User Details
output "iam_user_name" {
  description = "The user's name"
  value       = try(aws_iam_user.this[0].name, "")
}

output "iam_user_arn" {
  description = "The ARN assigned by AWS for this user"
  value       = try(aws_iam_user.this[0].arn, "")
}

output "iam_user_unique_id" {
  description = "The unique ID assigned by AWS"
  value       = try(aws_iam_user.this[0].unique_id, "")
}

output "iam_user_login_password" {
  description = "The encrypted password, base64 encoded"
  value       = try(aws_iam_user_login_profile.this[0].encrypted_password, "")
}

output "iam_access_key_id" {
  description = "The access key ID"
  value       = try(aws_iam_access_key.this[0].id, aws_iam_access_key.this_no_pgp[0].id, "")
}

output "iam_access_key_secret" {
  description = "The access key secret"
  value       = try(aws_iam_access_key.this_no_pgp[0].secret, "")
  sensitive   = true
}

output "iam_access_key_key_fingerprint" {
  description = "The fingerprint of the PGP key used to encrypt the secret"
  value       = try(aws_iam_access_key.this[0].key_fingerprint, "")
}

output "iam_access_key_encrypted_secret" {
  description = "The encrypted secret, base64 encoded"
  value       = try(aws_iam_access_key.this[0].encrypted_secret, "")
}
