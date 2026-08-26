output "s3_access_policy_arn" {
  value = aws_iam_policy.s3_access.arn
}

output "rds_access_policy_arn" {
  value = aws_iam_policy.rds_access.arn
}