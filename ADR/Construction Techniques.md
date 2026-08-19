# Libraries 
## Python 
- Requests
- Boto3
- AWSCLI
- Pandas
  
# Frameworks 

## Medallion Architecture 
The Medallion Architecture consists of 3 layers 

### Bronze 
Represents raw data with no schema / transformations applied. 

### Silver 
Represents cleaned data; will contain historical data within. 

### Gold 
Contains aggregated / up-to-date data used for data modelling. 

## Custom Framework 

The custom framework consists of 5 layers

### Metadata 
Consists of a table(s) containing instructions on how the sources and data will be handled. 

#### Columns 

- Source_Type
- Source_Name
- Connection
- Primary Key
- Compare Columns
- Load Type: Full or Delta (Incremental) 
- SCD Type: Accepted values, Type 1 and Type 2

### Staging
Consists of tables containing temporary tables containing data from each source. 
Tables are dropped and recreated after each run. 

### Persisted Source History (PSH) 
Consists of tables which retain the history of records being populated within each table. 

### Surrogate Key 
Consists of tables which handle the surrogate keys. 
Can be skipped if the dimensions are classified as Slowly Changing Dimensions. 
### Transformation 
Consists of custom transformations applied to each source. 
Dependent on the source system. 

### Dimensional Model 
Consists of fully cleaned tables ready for data modelling. 

# Tools 
- AWS
- Python 

# Processes 
- Test Driven Development

