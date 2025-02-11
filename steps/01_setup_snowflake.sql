USE ROLE ACCOUNTADMIN;

CREATE OR ALTER WAREHOUSE QUICKSTART_WH 
  WAREHOUSE_SIZE = XSMALL 
  AUTO_SUSPEND = 300 
  AUTO_RESUME= TRUE;


-- Separate database for git repository
CREATE OR ALTER DATABASE QUICKSTART_COMMON;


-- API integration is needed for GitHub integration
CREATE OR REPLACE api integration GIT_API_INTEGRATION
    api_provider = git_https_api
    api_allowed_prefixes = ('https://github.com/chandrapratapsingh08')
    enabled = true
    allowed_authentication_secrets = all

-- Git repository object is similar to external stage
CREATE OR REPLACE GIT REPOSITORY quickstart_common.public.quickstart_repo
  API_INTEGRATION = GIT_API_INTEGRATION
  ORIGIN = 'https://github.com/chandrapratapsingh08/snowflake_devops'; -- INSERT URL OF FORKED REPO HERE

CREATE OR ALTER DATABASE QUICKSTART_PROD;


-- To monitor data pipeline's completion
CREATE OR REPLACE NOTIFICATION INTEGRATION email_integration
  TYPE=EMAIL
  ENABLED=TRUE;


-- Database level objects
CREATE OR ALTER SCHEMA bronze;
CREATE OR ALTER SCHEMA silver;
CREATE OR ALTER SCHEMA gold;


-- Schema level objects
CREATE OR REPLACE FILE FORMAT bronze.json_format TYPE = 'json';
CREATE OR ALTER STAGE bronze.raw;


-- Copy file from GitHub to internal stage
copy files into @bronze.raw from @quickstart_common.public.snowflake_devops/branches/main/data/airport_list.json;
