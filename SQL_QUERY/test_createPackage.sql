-- Declaring a TVP, to send a list inside a Stored procedure
DECLARE @serviceItems dbo.ServiceItemList;
INSERT INTO @serviceItems (serviceItemID,quantity)
VALUES (1,3),(2,2),(3,4);
DECLARE @PackageName1 VARCHAR(50) = 'Package Name';
DECLARE @Description1 VARCHAR(50) = 'Package Description';
DECLARE @ValidPeriodStartDate1 DATE = '2023-06-01';
DECLARE @ValidPeriodEndDate1 DATE = '2023-06-30';
DECLARE @AdvertisedPrice1 DECIMAL(10, 2) = 100.00;
DECLARE @AdvertisedCurrency1 VARCHAR(10) = 'USD';
DECLARE @EmployeeID1 INT = 1; 
DECLARE @AdvertisedPackageID1 INT;
DECLARE @statusCode1 varchar(20) = 'Active';

-- Executing Stored Procedure named usp_createPackage
EXECUTE usp_createPackage
    @PackageName1,
    @serviceItems,
    @Description1,
    @ValidPeriodStartDate1,
    @ValidPeriodEndDate1,
    @AdvertisedPrice1,
    @AdvertisedCurrency1,
    @EmployeeID1, 
	@statusCode1,
    @AdvertisedPackageID1 OUTPUT;

-- To show the output of the ID
SELECT @AdvertisedPackageID1 AS AdvertisedPackageID;
-- for testing purposes ---
SELECT * FROM AdvertisedPackage;
SELECT * FROM ServiceItem;
SELECT * FROM AdvertisedService;


