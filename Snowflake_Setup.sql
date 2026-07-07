 -- PowerBI S3 integration, staging, and agriculture dataset pipeline
-- Co-authored with CoCo
CREATE OR REPLACE STORAGE INTEGRATION PBI_Integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::320503429973:role/nkspowerbi.role'
  STORAGE_ALLOWED_LOCATIONS = ('s3://nkspowerbi.bucket/')
  COMMENT = 'Optional Comment';

   desc integration PBI_Integration;

   CREATE database PowerBI;

create schema PBI_Data;

create table PBI_Dataset (
Year int,	Location string,	Area	int,
Rainfall	float, Temperature	float, Soil_type string,
Irrigation	string, yeilds	int,Humidity	float,
Crops	string,price	int,Season string



);

select * from PBI_Dataset;

//drop database test;

create stage PowerBI.PBI_Data.pbi_stage
url = 's3://nkspowerbi.bucket'
storage_integration = PBI_Integration;

//desc stage s1

//drop stage s1;


copy into PBI_Dataset 
from @pbi_stage
file_format = (type=csv field_delimiter=',' skip_header=1 )
on_error = 'continue';

list @pbi_stage;

create table agriculture as
select * from PBI_DATASET;

select * from agriculture;

alter table agriculture
add Year_group string;

        
alter table agriculture
add rainfall_group string;

update agriculture
SET rainfall_group = 
    CASE WHEN year >=2004 and year <=2010 then 'Y1'
         WHEN year >=2011 and year <=2015 then 'Y2'
         ELSE 'Y3' END;

update agriculture
SET rainfall_group = 
    CASE WHEN RAINFALL >200 and RAINFALL <=1200 then 'LOW'
         WHEN RAINFALL >1200 and RAINFALL <=2500 then 'MEDIUM'
         ELSE 'HIGH' END;
    