{
  "Version": "2012-10-17",
  "Id": "kms-key-policy",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {"AWS": "arn:aws:iam::${account_id}:root"},
      "Action": "kms:*",
      "Resource": "*"
    },
    {
      "Sid": "Minimal Permissions",
      "Effect": "Allow",
      "Principal": {"AWS": "arn:aws:iam::${account_id}:role/${role_name}"},
      "Action": [
        "kms:Decrypt",
        "kms:GenerateDataKeyWithoutPlaintext",
        "kms:CreateGrant"
      ],
        "Resource": "*"
    }
  ]
}