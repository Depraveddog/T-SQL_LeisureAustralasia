
-- Creating TVP for serviceitems to be able to pass them into a list in Stored Procedure
CREATE TYPE dbo.ServiceItemList AS TABLE (
    serviceItemID int primary key,
    quantity INT
);

GO
-- Creating stored procedure
CREATE PROCEDURE usp_createPackage
    @packageName VARCHAR(50),
    @serviceItemList dbo.ServiceItemList READONLY,
    @description VARCHAR(50),
    @validPeriodStartDate DATE,
    @validPeriodEndDate DATE,
    @advertisedPrice DECIMAL(10, 2),
    @advertisedCurrency VARCHAR(10),
    @employeeID INT,
	@statusCode varchar(20),
    @advertisedPackageID INT OUTPUT
AS
BEGIN
-- Executing try and catch for error handling
   BEGIN TRY
-- Stopping the message of how many rows are being affected
    SET NOCOUNT ON;
-- declaring variables inside SP
    DECLARE @packageID INT;
    INSERT INTO AdvertisedPackage (name, description, startDate, endDate, price, currencySymbol, employeeID, statusCode)
    VALUES (@packageName, @description, @validPeriodStartDate, @validPeriodEndDate, @advertisedPrice, @advertisedCurrency, @employeeID, @statusCode);
-- Our table are created with identity(1,1) primary key, so in order to get the newly created ID we used scope identity

    SET @advertisedPackageID = SCOPE_IDENTITY();
-- Inserting data into Advertised service, a composite key to be able to identify the advertisedpackage and their relations with the serviceitems
    INSERT INTO AdvertisedService (adPackID, serviceItemID, quantity)
    SELECT @advertisedPackageID, serviceItemID, quantity
    FROM @serviceItemList;

END TRY 
 BEGIN CATCH 
 -- a simple error handling, to show the user what kind of error and the severity, state
   Declare @errorMessage nvarchar(200) = error_message();
   Declare @errorSeverity INT = error_severity();
   Declare @errorState INT = error_state();

   PRINT 'There is an error when executing' + @errorMessage;
   PRINT 'The error severity is :  ' +@errorSeverity;
   Print 'The error state is : ' + @errorState;

END CATCH
END