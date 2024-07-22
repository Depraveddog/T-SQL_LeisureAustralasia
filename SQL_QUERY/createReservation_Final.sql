-- Creating a TVP type for advertisedPackage list input purposes
CREATE type bookingReservedItems as TABLE (
advertisedPackageID INT,
quantity INT,
startDate date,
endDate date
);

-- Creating a TVP type for Guest list input purposes
Create type customerGuestList as Table (
guestName varchar(50),
guestDOB date,
guestStreet varchar(50),
guestUnitNo varchar(50),
guestPostalCode varchar(50),
guestLocationID int,
tellNo varchar(50),
guestEmail varchar(50));

GO

CREATE PROCEDURE usp_makeReservation
@hotelID int,
@customerName VARCHAR(50),
@customerDob date,
@street VARCHAR(50),
@unitNo VARCHAR(50),
@postalCode Varchar(50),
@locationID varchar(50),
@tellNo VARCHAR(50),
@email VARCHAR(50),
@payment1 VARCHAR(50),
@bookingStartDate date,
@bookingEndDate date,
@bookedServices dbo.bookingReservedItems READONLY,
@customerGuestList dbo.customerGuestList READONLY,
@reservationID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @totalAmount DECIMAL(10, 2);
    DECLARE @depositDue DECIMAL(10, 2);
    DECLARE @capacityCheck TABLE (
        serviceItemId INT,
        remainingCapacity INT
    );

    DECLARE @customerIDz INT;
    DECLARE @bookingIDz INT;
    DECLARE @guestIDz INT;
    DECLARE @totalCapacity INT;
    DECLARE @totalReservations INT;
    DECLARE @customerAddressID INT;
    DECLARE @reservationIDList table (reservationID INT);
    DECLARE @facilityTypeID INT;

    -- Check the total capacity of the hotel by joining the Capacity table
    SELECT @totalCapacity = c.size
    FROM Hotel h
    INNER JOIN Capacity c ON h.capacityID = c.capacityID
    WHERE h.hotelID = @hotelID;

    -- Check total reservations and the dates in TVP booked services
    SELECT @totalReservations = COUNT(*)
    FROM Reservation
    WHERE hotelID = @hotelID
    AND EXISTS (
        SELECT 1
        FROM @bookedServices bs
        WHERE startDate <= bs.endDate
        AND endDate >= bs.startDate
    );

    -- For debugging purposes, to check outcome on the message panel
    PRINT 'Total Reservations: ' + CONVERT(VARCHAR(10), @totalReservations);

    -- Using if statement to check if totalReservation exceed over total capacity
    IF (@totalReservations + 1) > @totalCapacity
    BEGIN
        -- Raise an error if the reservation exceeds the hotel capacity (severity: 16)
        RAISERROR('The reservation exceeds the hotel capacity.', 16, 1);
        RETURN;
    END;

    -- calculating the total amount of the advertised packages and storing it in total amount
    SET @totalAmount = (
        SELECT SUM(br.quantity * ap.price)
        FROM @bookedServices br
        INNER JOIN AdvertisedPackage ap ON br.advertisedPackageID = ap.adPackID
    );

    -- for debug purposes to store in the message to see the output
    PRINT 'Total Amount: ' + CONVERT(VARCHAR(50), @totalAmount);

    -- Calculate 25% deposit of the total amount for deposit due and storing it in depositDue variable
    SET @depositDue = ISNULL(@totalAmount * 0.25, 0);
    PRINT 'Deposit Due: ' + CONVERT(VARCHAR(50), @depositDue);

    -- Insert values into the CustomerGuestAddress table
    INSERT INTO CustomerGuestAddress (unitNo, street, postalCode, locationID)
    VALUES (@unitNo, @street, @postalCode, @locationID);

	-- Since we are using an identity primary key, we are using scope identity to extract the latest generated ID when a value is placed
    SET @customerAddressID = SCOPE_IDENTITY();

    -- Insert values into the Customer table with input variables 
    INSERT INTO Customer (name, customerAddressID, tellNo, email, DOB)
    VALUES (@customerName, @customerAddressID, @tellNo, @email, @customerDob);

    -- Since we are using an identity primary key, we are using scope identity to extract the latest generated ID when a value is placed
    SET @customerIDz = SCOPE_IDENTITY();
    -- Debug purposes
    PRINT 'Customer ID: ' + CONVERT(VARCHAR(50), @customerIDz);

    -- Insert into CustomerGuestAddress table for both customer and guest as they might be staying in the same apartment
    INSERT INTO CustomerGuestAddress (unitNo, street, postalCode, locationID)
    SELECT cg.guestUnitNo, cg.guestStreet, cg.guestPostalCode, cg.guestLocationID
    FROM @customerGuestList cg;

	-- Since we are using an identity primary key, we are using scope identity to extract the latest generated ID when a value is placed
    SET @customerAddressID = SCOPE_IDENTITY();

    -- Insert into the Guest table for storing guest details
    INSERT INTO Guest (name, customerAddressID, tellNo, email, customerID, DOB)
    SELECT cg.guestName, @customerAddressID, cg.tellNo, cg.guestEmail, @customerIDz, cg.guestDOB
    FROM @customerGuestList cg;

    -- Since we are using an identity primary key, we are using scope identity to extract the latest generated ID when a value is placed
    SET @guestIDz = SCOPE_IDENTITY();

    -- Get the facility type ID
    SELECT @facilityTypeID = si.facilityTypeID
    FROM ServiceItem si
    JOIN AdvertisedService asv ON si.serviceItemID = asv.serviceItemID
    WHERE asv.adPackID = (SELECT TOP 1 advertisedPackageID FROM @bookedServices br);

	-- Insert data into the Reservation table and store the generated reservation ID in a list

   INSERT INTO Reservation (deposit, customerID, payment, hotelID)
   OUTPUT inserted.reservationID INTO @reservationIDList (reservationID)
   SELECT @depositDue, @customerIDz, @payment1, @hotelID
   FROM @bookedServices;

   -- Since we are using an identity primary key, we are using scope identity to extract the latest generated ID when a value is placed
   SET @reservationID = SCOPE_IDENTITY();
   -- Select the reservation IDs from the @reservationIDList table variable to display the newly generated reservation ids
   SELECT reservationID FROM @reservationIDList;

   -- Inserting data with the reservation list and inserting the rest of the generated data. The reason why we used row_number is to uniquely identify and place non-duplicate data
  INSERT INTO Booking (reservationId, adPackID, quantity, customerID, startDate, endDate, facilityTypeID)
  SELECT rl.reservationID, bs.advertisedPackageID, bs.quantity, @customerIDz, @bookingStartDate, @bookingEndDate, si.facilityTypeID
  FROM (
  SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rowNumber, reservationID
  FROM @reservationIDList
   ) rl
  JOIN (
    SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rowNumber, advertisedPackageID, quantity
    FROM @bookedServices
  ) bs ON rl.rowNumber = bs.rowNumber
  JOIN ServiceItem si ON bs.advertisedPackageID = si.serviceItemID;

END

