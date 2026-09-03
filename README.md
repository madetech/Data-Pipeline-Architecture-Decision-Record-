# MadeTech-Severless-Data-Pipeline

# Purpose 

The purpose of the project is to create a low-cost, serverless data pipeline on AWS. 

Utilising an Event Driven Architecture (EDA), data from an api is processed via two lambda functions: **api_extraction** and **data_transformation**; with an S3 bucket acting as a staging area to house the extracted data. 

AWS Eventbridge acts as a trigger to call the **data_transformation** lambda function, which is responsible for transforming and loading the data to an AWS RDS. 


# High Level Overview Diagram 
<img width="954" height="289" alt="Screenshot 2026-09-03 at 17 07 31" src="https://github.com/user-attachments/assets/d0aa0771-0b91-487b-bd47-aa844f769c12" />


# Use Cases 

- To act as an MVP for MadeTech clients looking for a cost-effective, Software as a Service (SaaS) solution. 

- To provide an automated, reusable, event-driven pipeline framework. 
