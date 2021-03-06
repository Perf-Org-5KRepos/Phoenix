﻿--------------------------------------------------
-- Insert/Update/Delete script for table AzureRegion
--------------------------------------------------
 
 
SET NOCOUNT ON
--SET IDENTITY_INSERT AzureRegion ON
 
CREATE TABLE #WorkTable (
[AzureRegionId] [int] NOT NULL
, [Name] [nvarchar] (100) NOT NULL
, [Description] [nvarchar] (500) NOT NULL
, [OsImageContainer] [varchar] (max) NULL
, [IsActive] [bit]  NOT NULL
, [CreatedOn] [datetime]  NOT NULL
, [CreatedBy] [nvarchar] (256) NOT NULL
, [LastUpdatedOn] [datetime]  NOT NULL
, [LastUpdatedBy] [varchar] (50) NOT NULL
)
GO
 
DECLARE 
     @vInsertedRows INT
    , @vUpdatedRows INT
    , @vDeletedRows INT
    , @vNow         DATETIME
 
SELECT @vNow = GETDATE()
 
--------------------------------------------------
-- Populate base temp table. 
--------------------------------------------------

INSERT #WorkTable 
([AzureRegionId], [Name], [Description], [OsImageContainer], [IsActive], [CreatedOn], [CreatedBy], [LastUpdatedOn], [LastUpdatedBy]) 
SELECT 1, N'centralus', N'Central US', NULL, 1, CAST(N'2016-02-19 23:52:46.340' AS DateTime), N'CMP WAP Extension Installer', CAST(N'2016-02-19 23:52:46.340' AS DateTime), N'CMP WAP Extension Installer'
UNION ALL
SELECT 2, N'eastus', N'East US', NULL, 1, CAST(N'2016-02-19 23:52:46.340' AS DateTime), N'CMP WAP Extension Installer', CAST(N'2016-02-19 23:52:46.340' AS DateTime), N'CMP WAP Extension Installer'
UNION ALL
SELECT 3, N'eastus2', N'East US 2', NULL, 1, CAST(N'2016-02-19 23:52:46.340' AS DateTime), N'CMP WAP Extension Installer', CAST(N'2016-02-19 23:52:46.340' AS DateTime), N'CMP WAP Extension Installer'
UNION ALL
SELECT 4, N'westus', N'West US', NULL, 1, CAST(N'2016-02-19 23:52:46.340' AS DateTime), N'CMP WAP Extension Installer', CAST(N'2016-02-19 23:52:46.340' AS DateTime), N'CMP WAP Extension Installer'
UNION ALL
SELECT 5, N'northcentralus', N'North Central US', NULL, 1, CAST(N'2016-02-19 23:52:46.340' AS DateTime), N'CMP WAP Extension Installer', CAST(N'2016-02-19 23:52:46.340' AS DateTime), N'CMP WAP Extension Installer'
UNION ALL
SELECT 6, N'southcentralus', N'South Central US', NULL, 1, CAST(N'2016-02-19 23:52:46.340' AS DateTime), N'CMP WAP Extension Installer', CAST(N'2016-02-19 23:52:46.340' AS DateTime), N'CMP WAP Extension Installer'

 
-----------------------------------------------------
-- Begin script transaction
-----------------------------------------------------
 
BEGIN TRAN
 
 
--------------------------------------------------
-- UPDATE existing data. 
--------------------------------------------------
-- Dev Note - Update will not update ' to NULL OR 0 to NULL
UPDATE AzureRegion
SET   Name = source.Name
        , Description = source.Description
        , OsImageContainer = source.OsImageContainer
        , IsActive = source.IsActive
        , CreatedOn = source.CreatedOn
        , CreatedBy = source.CreatedBy
        , LastUpdatedOn = source.LastUpdatedOn
        , LastUpdatedBy = source.LastUpdatedBy

FROM #WorkTable source
    JOIN AzureRegion target
    ON      source.Name = target.Name
    AND ( ISNULL(source.Name , '') <>  ISNULL(target.Name , '')
    OR  ISNULL(source.Description , '') <>  ISNULL(target.Description , '')
    OR  ISNULL(source.OsImageContainer , '') <>  ISNULL(target.OsImageContainer , '')
    OR  ISNULL(source.IsActive , 0) <>  ISNULL(target.IsActive , 0)
    OR  ISNULL(source.CreatedOn , '') <>  ISNULL(target.CreatedOn , '')
    OR  ISNULL(source.CreatedBy , '') <>  ISNULL(target.CreatedBy , '')
    OR  ISNULL(source.LastUpdatedOn , '') <>  ISNULL(target.LastUpdatedOn , '')
    OR  ISNULL(source.LastUpdatedBy , '') <>  ISNULL(target.LastUpdatedBy , '')
    )
 
SELECT @vUpdatedRows = @@ROWCOUNT
 
--------------------------------------------------
-- Insert new data. 
--------------------------------------------------
INSERT AzureRegion
    (Name, Description, OsImageContainer, IsActive, CreatedOn, CreatedBy, LastUpdatedOn, LastUpdatedBy)
SELECT
    Name, Description, OsImageContainer, IsActive, CreatedOn, CreatedBy, LastUpdatedOn, LastUpdatedBy
FROM #WorkTable source
WHERE NOT EXISTS(SELECT * 
FROM AzureRegion target
WHERE 
    source.AzureRegionId = target.AzureRegionId

)
 
SELECT @vInsertedRows = @@ROWCOUNT
 
--------------------------------------------------
-- Delete non matching data. 
--------------------------------------------------
DELETE AzureRegion
FROM AzureRegion target
WHERE NOT EXISTS (
    SELECT * 
    FROM #WorkTable source 
    WHERE     source.Name = target.Name

)
 
SELECT @vDeletedRows = @@ROWCOUNT
 
 
GOTO SuccessfulExit 
 
FailureExit:
    ROLLBACK
SET IDENTITY_INSERT AzureRegion OFF
    RETURN
 
SuccessfulExit:
    PRINT 'Data for AzureRegion modified. Inserted: ' + CONVERT(VARCHAR(10), @vInsertedRows) + ' rows. Updated: ' + CONVERT(VARCHAR(10), @vUpdatedRows) + ' rows. Deleted: ' + CONVERT(VARCHAR(10), ISNULL(@vDeletedRows, 0)) + ' rows'
    COMMIT
SET IDENTITY_INSERT AzureRegion OFF
 
--------------------------------------------------
-- Drop temp table 
--------------------------------------------------
GO
DROP TABLE #WorkTable
GO
