# ---------------------------------------------------
# S3 access policy
# ---------------------------------------------------
data "aws_iam_policy_document" "s3_access" {
  statement {
    sid     = "S3ReadWrite"
    effect  = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket"
    ]
    resources = [
      var.s3_bucket_arn,
      "${var.s3_bucket_arn}/*"
    ]
  }
}

resource "aws_iam_policy" "s3_access" {
  name        = "${var.project_name}-s3-access"
  description = "Access policy for ${var.s3_bucket_arn}"
  policy      = data.aws_iam_policy_document.s3_access.json
}

# ---------------------------------------------------
# RDS access policy
# ---------------------------------------------------
data "aws_iam_policy_document" "rds_access" {
  statement {
    sid     = "RDSConnect"
    effect  = "Allow"
    actions = [
      "rds-db:connect"
    ]
    resources = [var.rds_arn]
  }

  statement {
    sid     = "RDSDescribe"
    effect  = "Allow"
    actions = [
      "rds:DescribeDBInstances",
      "rds:ListTagsForResource"
    ]
    resources = [var.rds_arn]
  }
}

resource "aws_iam_policy" "rds_access" {
  name        = "${var.project_name}-rds-access"
  description = "Access policy for ${var.rds_arn}"
  policy      = data.aws_iam_policy_document.rds_access.json
}