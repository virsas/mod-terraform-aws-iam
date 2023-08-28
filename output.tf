output "saml_arn" {
  value = try(aws_iam_saml_provider.vss[0].arn, "")
}
output "saml_valid_until" {
  value = try(aws_iam_saml_provider.vss[0].valid_until, "")
}
output "user_arn" {
  value = try(aws_iam_user.vss[0].arn, "")
}
output "user_name" {
  value = try(aws_iam_user.vss[0].name, "")
}
output "user_unique_id" {
  value = try(aws_iam_user.vss[0].unique_id, "")
}
output "access_key_created_date" {
  value = try(aws_iam_access_key.vss[0].created_date, "")
}
output "access_key_id" {
  value = try(aws_iam_access_key.vss[0].id, "")
}
output "access_key_secret" {
  value = try(aws_iam_access_key.vss[0].secret, "")
}
output "access_key_encrypted_secret" {
  value = try(aws_iam_access_key.vss[0].encrypted_secret, "")
}
output "access_key_key_fingerprint" {
  value = try(aws_iam_access_key.vss[0].key_fingerprint, "")
}
output "access_key_ses_smtp_password_v4" {
  value = try(aws_iam_access_key.vss[0].ses_smtp_password_v4, "")
}
output "access_key_encrypted_ses_smtp_password_v4" {
  value = try(aws_iam_access_key.vss[0].encrypted_ses_smtp_password_v4, "")
}