# Overview 
Last Updated: 20/08/2026

This document details the decisions made for the project. 

# 001 - Choosing The Cloud Provider

## Context 
The project involves creating an ETL pipeline, which can be reliably scaled to meet extra demands such as: 

- Increased volumes of data
- Increased variety sources of data

The solution must be cost efficient, and require minimal maintenance once implemented. 


### Options Considered 
- Azure (Microsoft Azure)
- AWS (Amazon Web Services)
- GCP (Google Cloud Platform)

Currently, MadeTech has cloud sandboxes within AWS and Azure, with no GCP sandbox at the time of writing. 

## Decision 
Due to the availability of Cloud sandboxes within MadeTech, AWS was chosen as the cloud platform of choice. 


## Consequences 
### Advantages 
- Current sandbox infrastructure allows for simple deployments, and maintenance.
- A larger array of specialised tools and services to allow for project expansion.
  
### Disadvantages 
- AWS Sandbox is torn down at the end of each week, Friday midday, meaning resources will need to be recreated at the start of each week.

### Considerations for Disadvantages 
- Utilise Infrastructure as Code Tools, such as AWS CloudFormation or Terraform to automate the creation of resources on AWS.

  
# 002 - API Extraction Decision 

## Context 
APIs allow users to access and consume data and services from various independent resources. 

They can be used to run test data, and work with real datasets.

### Options Considered 
- Source Databases
- Semi Structured File Formats (i.e. .csv, excel files or .json) 
- Kafka Topics 
- Secure File Transfer Protocol (SFTP)
- APIs

## Decision 
The decision is to use APIs, due to their flexibility, and ability to retrieve data from different types of sources. 

The plan is to use APIs which contain testing data, then move onto other APIs, which contain realistic datasets. 

A list of public APIs can be found here. 

https://github.com/public-apis/public-apis

While Kafka Topics, Source Databases and SFTP provide resilient, stable sources for the extraction of data, these systems would need to be configured within the AWS environment before extracting data from these systems. 

The cost overheads are also higher for maintaining these systems. 
Furthermore, the AWS sandbox removes these resources every week, meaning they would need to be reconfigured at the start of each week -- creating higher amounts of technical debt. 

Semi Structured File Formats would need to be created manually, and uploaded to a staging area. 

While the semi-structured file formats are an ideal solution, the manual creation, configuration and uploading of these resources creates extra manual processing, which the pipeline aims to avoid. 
## Consequences

### Advantages 
- Allows for retrieval of data from different, and varied sources
- No up front cost to set up a back-end data retrieval system such as a source database or SFTP server. 
### Disadvantages 
- Authentication methods vary depending on the API
- Different APIs have different methodologies of retrieving data, leading to increased technical debt on the API Extraction script. 

# 003 - Component Decision: AWS Lambda 

## Context 
AWS Lambda allows for users to run serverless functions within AWS. 
Billing for Lambdas only occurs during their execution, and the number of requests made, making them a lightweight solution for the scope of this project. 

https://aws.amazon.com/lambda/pricing/

### Other Options Considered 
- AWS Glue
- AWS Redshift
- AWS Databricks
- *Talend
- *Integrate.io

* No to low-code tools to automate AWS Pipelines.

## Decision 
After careful consideration, the decision is to go with AWS lambda due to its low cost and versatility. 

For the scope of the project, two AWS Lambdas can be created. 
The first lambda being responsible for the API Extraction and the second lambda being responsible for data transformations. 

Other options such as AWS Redshift, AWS Glue and AWS Databricks incur greater costs. 
 

## Consequences 
### Advantages 
- Low cost per request in comparison to other services
- Can be written in a variety of programming languages
### Disadvantages
- High code solution: can create further technical debt.
- Long term support issues with runtime code versions. AWS will not support failed lambda functions if the runtime code version is no longer supported by AWS.
  
# 004 Component Decision: AWS S3

## Context 
The project requires a staging area used to store files and outputs generated from extracting data from the API 
### Other Options Considered 
- Amazon FSx
- Amazon Elastic File System (EFS)
- Amazon Elastic Block Store (EBS)

## Decision 
The decision is to use AWS S3 due to its high scalability and low storage cost per object. 

## Consequences 
### Advantages 
- Cost per object storage is cheaper than alternatives.
- Files can be moved into different storage tiers depending on the use case. 
### Disadvantages 
- Requires specific fine-grained IAM Roles and permissions to access Buckets.
# 005 - Component Decision: AWS EventBridge 

## Context 
To automate the process between when a file is landed, and when a file is processed, the project requires usage of event driven architecture. 

Event driven architecture simplifies the typical batch processing load process; allowing for data to be processed at anytime.

### Other Considerations 
- Confluent
- Snowflake SnowPipe
- Amazon Eventbridge
- Amazon Simple Queue Service (SQS)
- Amazon Simple Notification Service (SNS)
- Amazon API Gateway

## Decision 
The decision is to use AWS EventBridge to act as a automation layer between AWS S3 and the AWS Lambda which is responsible for data transformations. 

## Consequences 
### Advantages 
- No to low-code interface with syncing services
- Can create different types of rules
- No upfront costs of usage
### Disadvantages
- Has a limit of up to 5 different AWS services
  
# 006 - Component Decision: AWS RDS 

## Context 

### Other Considerations 
- AWS DyanamoDB
- Amazon Aurora

## Decision 
The decision is to use AWS RDS, due to its high availabilty, and wide choice of database engines. 

Unlike DynamoDB, AWS RDS follows a strict Relational schema, which allows for consistent transactions between scripts and the database. 

Where DynamoDB has advantages in its NoSQL architecture. Extra considerations must be put in place to choosing the correct partition key for the data. 

Due to the volume and variety of data consumed by the APIs, DynamoDB would struggle to scale as more sources are added to the pipeline. 

### Database Engine Decision 
After thoughtful consideration, the decision is to use PostgreSQL for the database engine. 

This is due to PostgreSQL being open source, and its availability across the three main operating systems, Mac, Linux and Windows. 

PGAdmin4 or DBeaver make for simple user interfaces, which allow users to directly connect to the database to retrieve data. 

Furthermore, PostgreSQL supports schemas, which can be used to separate the different layers of the transformation process. 
## Consequences 

### Advantages 
- Automated database snapshots / backups
- Ability to control inbound / outbound networking rules for different users. 
### Disadvantages 
- Strict schema requirements
- Requires further configurations using user personas and profiles within the database. 
