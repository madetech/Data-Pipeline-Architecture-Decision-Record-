provider "aws" {
  region = "eu-west-2"
}
# IAM role for Lambda execution
# data "aws_iam_policy_document" "assume_role" {
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["lambda.amazonaws.com"]
#     }

#     actions = ["sts:AssumeRole"]
#   }
# }
# #TODO: Implement a role, which covers lambda execution and S3 access. 
# resource "aws_iam_role" "lambda_execution" {
#   name               = "lambda_execution_role"
#   assume_role_policy = data.aws_iam_policy_document.assume_role.json
# }
module "vpc" {
  source = "./modules/networking/vpc"

  project_name        = var.application_name
  availability_zone_a = "eu-west-2a"
  availability_zone_b = "eu-west-2b"
  subnet_group_name   = "rds-db-subnet-group"
  subnet_a_name       = "rds-subnet-1a"
  subnet_b_name       = "rds-subnet-1b"
  security_group_name = "rds-security-group"

}

# S3 Bucket Creation
module "s3" {
  source = "./modules/s3"
  bucket_name = "mt-serverless-data-pipeline-bucket-dev"
  versioning_enabled = false
  environment_name = var.environment_name
  project_name = "data-pipeline"
  
}

module "rds" {
  source = "./modules/rds"
  rds_identifier          = "dbapiextraction"  
  allocated_storage    = 10
  db_name              = "target_db"
  engine               = "postgres"
  engine_version       = "18.2"
  instance_class       = "db.t3.micro"
  rds_user             = "db_user"
  rds_password         = var.rds_password
  db_subnet_group_name = module.vpc.db_subnet_group_name
  skip_final_snapshot  = true
  publicly_accessible  = false 
  project_name         = var.application_name
}

module "iam" {
  source = "./modules/iam"

  project_name  = var.application_name
  s3_bucket_arn = module.s3.bucket_arn
  rds_arn       = module.rds.db_arn
}

# # Package the api extraction Lambda function code
# data "archive_file" "api_extraction" {
#  type        = "zip"
#  source_file = "${path.module}/src/lambda.py"
#  output_path = "${path.module}/lambda/api_extraction.zip"
# }

# # Package the data transformation Lambda function code
# data "archive_file" "data_transformation" {
#  type        = "zip"
#  source_file = "${path.module}/src/lambda.py"
#  output_path = "${path.module}/lambda/data_transformation.zip"
# }
# # API Extraction Lambda function
# resource "aws_lambda_function" "api_extraction" {
#   filename      = "${path.module}/lambda/api_extraction.zip"
#   function_name = "python_terraform_api_extraction"
#   role          = aws_iam_role.lambda_execution.arn
#   handler       = "index.handler"
#   source_code_hash = data.archive_file.api_extraction.output_base64sha256

#   runtime = "python3.10"

#   environment {
#     variables = {
#       Environment = var.environment_name
#       LOG_LEVEL   = var.log_level
#     }
#   }

#   tags = {
#     Environment = var.environment_name
#     Application = var.application_name
#   }
# }

# # Transformation Lambda function
# resource "aws_lambda_function" "data_transformation" {
#   filename      = "${path.module}/lambda/data_transformation.zip"
#   function_name = "python_terraform_data_transformation"
#   role          = aws_iam_role.lambda_execution.arn
#   handler       = "index.handler"
#   source_code_hash = data.archive_file.data_transformation.output_base64sha256

#   runtime = "python3.10"

#   environment {
#     variables = {
#       Environment = var.environment_name
#       LOG_LEVEL   = var.log_level
#     }
#   }

#   tags = {
#     Environment = var.environment_name
#     Application = var.application_name
#   }
# }

# # Adding CloudWatch Event Bus 
# resource "aws_cloudwatch_event_bus" "custom_bus" {
#   name = "my-custom-event-bus"
# }

# # The Rule (Filters the events passing through your bus)
# resource "aws_cloudwatch_event_rule" "lambda_rule" {
#   name           = "route-to-lambda-rule"
#   event_bus_name = aws_cloudwatch_event_bus.custom_bus.name

#   # Triggers for any event originating from "my.application"
#   event_pattern = jsonencode({
#     source = ["aws.s3"]
#     detail-type = ["Object Created"]
#     detail = {
#       bucket = {
#         name = [aws_s3_bucket.staging_area.id]
#       }
#     }
#   })
# }

# #TODO: Add to the resource block above to specify the location in which the event is triggered. 
# # Filters based on object file location matching a prefix string
#       # object = {
#       #   key = [{
#       #     prefix = "test_api/00_staged_files/" # Trailing slash ensures it targets only this folder block
#       #   }]
    
  
# # The Target (Connects the rule directly to data_transformation Lambda function)
# resource "aws_cloudwatch_event_target" "lambda_target" {
#   event_bus_name = aws_cloudwatch_event_bus.custom_bus.name
#   rule           = aws_cloudwatch_event_rule.lambda_rule.name
#   target_id      = "SendToLambda"
#   arn            = aws_lambda_function.data_transformation.arn # References your Lambda function ARN
# }

# # 4. The Permission (Crucial: Grants EventBridge authority to invoke the Lambda)
# resource "aws_lambda_permission" "allow_eventbridge" {
#   statement_id  = "AllowExecutionFromEventBridge"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.data_transformation.function_name
#   principal     = "events.amazonaws.com"
#   source_arn    = aws_cloudwatch_event_rule.lambda_rule.arn
# }