output "saml_arn" {
  value = try(aws_iam_saml_provider.vss[0].arn, "")
}
output "saml_valid_until" {
  value = try(aws_iam_saml_provider.vss[0].valid_until, "")
}