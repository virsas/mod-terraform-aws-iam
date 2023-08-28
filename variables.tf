# Account setup
variable "profile" {
  description           = "The profile from ~/.aws/credentials file used for authentication. By default it is the default profile."
  type                  = string
  default               = "default"
}

variable "accountID" {
  description           = "ID of your AWS account. It is a required variable normally used in JSON files or while assuming a role."
  type                  = string

  validation {
    condition           = length(var.accountID) == 12
    error_message       = "Please, provide a valid account ID."
  }
}

variable "region" {
  description           = "The region for the resources. By default it is eu-west-1."
  type                  = string
  default               = "eu-west-1"
}

variable "assumeRole" {
  description           = "Enable / Disable role assume. This is disabled by default and normally used for sub organization configuration."
  type                  = bool
  default               = false
}

variable "assumableRole" {
  description           = "The role the user will assume if assumeRole is enabled. By default, it is OrganizationAccountAccessRole."
  type                  = string
  default               = "OrganizationAccountAccessRole"
}

variable "password_configuration_enabled" {
  description           = "If set to true, password policy will be applied based on the configuration below."
  type                  = bool
  default               = false
}
variable "password_configuration_allow_users_to_change_password" {
  description           = "Allow IAM users to change their passwords. By default set to true."
  type                  = bool
  default               = true
}
variable "password_configuration_require_numbers" {
  description           = "If password requires at least one digit. By default set to true."
  type                  = bool
  default               = true
}
variable "password_configuration_require_symbols" {
  description           = "If password requires at least one symbol. By default set to true."
  type                  = bool
  default               = true
}
variable "password_configuration_require_lowercase_characters" {
  description           = "If password requires at least one lowercase character. By default set to true."
  type                  = bool
  default               = true
}
variable "password_configuration_require_uppercase_characters" {
  description           = "If password requires at least one uppercase character. By default set to true."
  type                  = bool
  default               = true
}
variable "password_configuration_minimum_length" {
  description           = "The minimum length of the password. By default set to 16."
  type                  = number
  default               = 16
}
variable "password_configuration_reuse_prevention" {
  description           = "How many times user must change their password before old one can be reused. By default set to 24."
  type                  = number
  default               = 24
}
variable "password_configuration_max_age" {
  description           = "How long can be the password used for before user is asked to change it. By default set to 90"
  type                  = number
  default               = 90
}

variable "analyzer_enabled" {
  description           = "Enable access analyzer. By default set to false."
  type                  = bool
  default               = false
}
variable "analyzer_type" {
  description           = "Type of the analyzer. Allowed values are ACCOUNT and ORGANIZATION. Defaults to ACCOUNT."
  type                  = string
  default               = "ACCOUNT"

  validation {
    condition           = contains(["ACCOUNT", "ORGANIZATION"], var.analyzer_type)
    error_message       = "Expected values: ACCOUNT or ORGANIZATION."
  }
}
variable "analyzer_name" {
  description           = "Name of the analyzer. By default set to: AccessAnalyzer"
  type                  = string
  default               = "AccessAnalyzer"
}

variable "saml_enabled" {
  description           = "Enable IAM SAML Provider configuration. Defaults to false."
  type                  = bool
  default               = false
}
variable "saml_name" {
  description           = "Name of the saml provider. This name is used for the file too. Defaults to SamlProvider and it would look for saml_path/SamlProvider.xml file"
  type                  = string
  default               = "SamlProvider"
}
variable "saml_path" {
  description           = "Path to xml files for iam saml configuration. Defaults to ./xml/iam"
  type                  = string
  default               = "./xml/iam"
}