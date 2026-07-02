-- run in sql server

/*
Create database and schemas 
Script Purpose:
Warning:  side effects caution like backups before running
 */

USE master;
GO

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
   ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE; --drop all current connections except this refuse further connections after dropping and revert any changes from dropped connections
   DROP DATABASE DataWarehouse;
END
GO

CREATE DATABASE DataWarehouse;
GO
USE DataWarehouse;

GO  --separator execute compeletely befor next command
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
