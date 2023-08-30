# mod-terraform-aws-acm

Terraform module to configure IAM users, groups, roles and passwords

## Variables

- **profile** - The profile from ~/.aws/credentials file used for authentication. By default it is the default profile.
- **accountID** - ID of your AWS account. It is a required variable normally used in JSON files or while assuming a role.
- **region** - The region for the resources. By default it is eu-west-1.
- **assumeRole** - Enable / Disable role assume. This is disabled by default and normally used for sub organization configuration.
- **assumableRole** - The role the user will assume if assumeRole is enabled. By default, it is OrganizationAccountAccessRole.
- **password_configuration_enabled** - If set to true, password policy will be applied based on the configuration below.
- **password_configuration_allow_users_to_change_password** - Allow IAM users to change their passwords. By default set to true.
- **password_configuration_require_numbers** - If password requires at least one digit. By default set to true.
- **password_configuration_require_symbols** - If password requires at least one symbol. By default set to true.
- **password_configuration_require_lowercase_characters** - If password requires at least one lowercase character. By default set to true.
- **password_configuration_require_uppercase_characters** - If password requires at least one uppercase character. By default set to true.
- **password_configuration_minimum_length** - The minimum length of the password. By default set to 16.
- **password_configuration_reuse_prevention** - How many times user must change their password before old one can be reused. By default set to 24.
- **password_configuration_max_age** - How long can be the password used for before user is asked to change it. By default set to 90.
- **analyzer_enabled** - Enable access analyzer. By default set to false.
- **analyzer_type** - Type of the analyzer. Allowed values are ACCOUNT and ORGANIZATION. Defaults to ACCOUNT.
- **analyzer_name** - Name of the analyzer. By default set to: AccessAnalyzer.
- **saml_enabled** - Enable IAM SAML Provider configuration. Defaults to false.
- **saml_name** - Name of the saml provider. This name is used for the file too. Defaults to SamlProvider and it would look for saml_path/SamlProvider.xml file
- **saml_path** - Path to xml files for iam saml configuration. Defaults to ./xml/iam
- **user_create** - Enable the process of user creation.
- **user_name** - Name of the iam user. Defaults to user.
- **user_path** - Path in which to create the user. Defaults to /.
- **user_force_destroy** - Whether to destroy user in case he created his own keys outside terraform. Defaults to true.
- **access_key_create** - Enable the process of access key creation. Defaults to false.
- **access_key_user_name** - The user name for whom to create the access key. Defaults to user.
- **policy_create** - Enable the process of policy creation. The policy can be then used by a group or role.
- **policy_name** - Name of the policy. Defaults to policy.
- **policy_environment** - If specified the policy will be named as policy_name, but the json file used will be combination of both name-environment.json. Defaults to empty string.
- **policy_path** - Path to json files for iam policy configuration. Defaults to ./json/iam/policy
- **role_create** - Enable the process of role creation. Defaults to false.
- **role_name** - Name of the role. Defaults to role.
- **role_environment** - If specified the role will be named as role_name, but the json file used will be combination of both name-environment.json. Defaults to empty string.
- **role_path** - Path to json files for iam role configuration. Defaults to ./json/iam/role
- **role_policies** - List of policy arns. Can be AWS predefined or your custom ones. Defaults to empty list.
- **role_session_duration** - Duration of the session the role can be used for. Defaults to 1 hour and can be set to 12 hours.
- **group_create** - Enable the process of group creation. Defaults to false.
- **group_name** - Name of the iam group. Defaults to group.
- **group_path** - Path in which to create the group. Defaults to /.
- **group_users** - List of user names attached to this group. Defaults to an empty list.
- **group_policy** - An ARN of a policy that should be attached to this group. Defaults to an empty string.

## Example

### Password policy

```terraform
module "iam_password" {
  source  = "git::https://github.com/virsas/mod-terraform-aws-iam.git?ref=v1.0.0"

  profile         = var.profile
  accountID       = data.aws_caller_identity.current.account_id

  password_configuration_enabled          = true
  password_configuration_minimum_length   = 14
  password_configuration_reuse_prevention = 0
}
```

### IAM user

```terraform
module "iam_user_admin" {
  source  = "git::https://github.com/virsas/mod-terraform-aws-iam.git?ref=v1.0.0"

  profile         = var.profile
  accountID       = data.aws_caller_identity.current.account_id

  user_create     = true
  user_name       = "admin"
}

module "iam_user_admin_key" {
  source  = "git::https://github.com/virsas/mod-terraform-aws-iam.git?ref=v1.0.0"

  profile         = var.profile
  accountID       = data.aws_caller_identity.current.account_id

  access_key_create     = true
  access_key_user_name  = module.iam_user_admin.user_name
}

module "iam_group_admin_policy" {
  source  = "git::https://github.com/virsas/mod-terraform-aws-iam.git?ref=v1.0.0"

  profile         = var.profile
  accountID       = data.aws_caller_identity.current.account_id

  policy_create   = true
  policy_path     = "./json/iam_groups"
  policy_name     = "admin"
}

module "iam_group_admin" {
  source  = "git::https://github.com/virsas/mod-terraform-aws-iam.git?ref=v1.0.0"

  profile         = var.profile
  accountID       = data.aws_caller_identity.current.account_id

  group_create    = true

  group_name      = "admin"
  group_policy    = module.iam_group_admin_policy.policy_arn
  group_users     = [module.iam_user_admin.user_name]
}

output "admin_secret" {
    value = module.iam_user_admin_key.access_key_secret
    sensitive = true
}
```

./json/iam_groups

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "*",
      "Resource": "*"
    }
  ]
}
```

### Role with predefined policy

```terraform
module "iam_role_AWSSupport" {
  source  = "git::https://github.com/virsas/mod-terraform-aws-iam.git?ref=v1.0.0"

  profile             = var.profile
  accountID           = data.aws_caller_identity.current.account_id

  role_create         = true
  role_path           = "./json/iam_roles"
  role_name           = "AWSSupport"
  role_environment    = var.environment
  role_policies       = ["arn:aws:iam::aws:policy/AWSSupportAccess"]
}
```

./json/iam_roles/AWSSupport-production.json

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::123456789012:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {}
    }
  ]
}
```

### Role with custom policy

```terraform
module "iam_role_ec2_policy" {
  source  = "git::https://github.com/virsas/mod-terraform-aws-iam.git?ref=v1.0.0"

  profile         = var.profile
  accountID       = data.aws_caller_identity.current.account_id

  policy_create   = true
  policy_path     = "./json/iam_policies"
  policy_name     = "ec2"
}

module "iam_role_ec2" {
  source  = "git::https://github.com/virsas/mod-terraform-aws-iam.git?ref=v1.0.0"

  profile         = var.profile
  accountID       = data.aws_caller_identity.current.account_id

  role_create     = true
  role_path       = "./json/iam_roles"
  role_name       = "ec2"
  role_policies   = [module.iam_role_ec2_policy.policy_arn]
}
```

./json/iam_roles/ec2.json

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    }
  ]
}
```

./json/iam_policies/ec2.json

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["ec2:DescribeTags"],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": ["xray:*"],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecs:CreateCluster",
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Poll",
        "ecs:RegisterContainerInstance",
        "ecs:StartTelemetrySession",
        "ecs:UpdateContainerInstancesState",
        "ecs:Submit*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage"
      ],
      "Resource": "*"
    }
  ]
}
```

### Google SAML Provider

```terraform
module "google_saml_provider" {
  source  = "git::https://github.com/virsas/mod-terraform-aws-iam.git?ref=v1.0.0"

  profile         = var.profile
  accountID       = data.aws_caller_identity.current.account_id

  saml_enabled    = true
  saml_name       = "googleAuth"
  saml_path       = "./xml"
}

output "GoogleAuthProviderArn" {
    value = module.google_saml_provider.saml_arn
}
```

./xml/googleAuth.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<md:EntityDescriptor>
  <md:IDPSSODescriptor>
    <md:KeyDescriptor>
      <ds:KeyInfo>
        <ds:X509Data>
          <ds:X509Certificate></ds:X509Certificate>
        </ds:X509Data>
      </ds:KeyInfo>
    </md:KeyDescriptor>
    <md:NameIDFormat></md:NameIDFormat>
    <md:SingleSignOnService/>
    <md:SingleSignOnService/>
  </md:IDPSSODescriptor>
</md:EntityDescriptor>
```

## Outputs

- saml_arn
- saml_valid_until
- user_arn
- user_name
- user_unique_id
- access_key_create_date
- access_key_id
- access_key_secret
- access_key_encrypted_secret
- access_key_key_fingerprint
- access_key_ses_smtp_password_v4
- access_key_encrypted_ses_smtp_password_v4
- policy_id
- policy_arn
- policy_name
- policy_policy
- policy_policy_id
- role_id
- role_arn
- role_name
- role_unique_id
- profile_id
- profile_arn
- group_id
- group_arn
- group_name
- group_unique_id
- group_membership_name
- group_membership_users
- group_membership_group
