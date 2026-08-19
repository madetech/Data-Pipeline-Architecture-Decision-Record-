# Dependencies 

## AWS Lambda: API Extraction to AWS S3 
An AWS IAM Role, which has the following permissions: 

- s3:GetObject
- s3:ListBucket
- s3:GetBucketLocation
- s3:PutObject
  
AWSLambdaExecute covers the permissions needed
<img width="947" height="462" alt="image" src="https://github.com/user-attachments/assets/39bba8a4-e576-49b8-b938-1239a34a8ed4" />

## AWS S3 to EventBridge 

Creation of an EventBridge with event pattern. 
EventBridge to trigger the Data Transformation Lambda when a file is landed in S3. 

## AWS Transformations Lambda to AWS RDS 

Creation of networking rules to allow traffic between the AWS Lambda function and the AWS RDS to allow the Lambda function to connect to the database. 

AmazonRDSServiceRole Policy covers a portion of this requirement. 


