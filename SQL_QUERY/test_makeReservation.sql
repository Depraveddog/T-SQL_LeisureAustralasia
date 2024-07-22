	
-- Testing Stored Procedure for make reservation
DECLARE @customerName1 VARCHAR(50) = 'Steve Bob';
DECLARE @customerDob1 date = '1999-12-11';
DECLARE @tellNo1 VARCHAR(50) = '831931883';
DECLARE @email1 VARCHAR(50) = 'stevebob@gmail.com';
DECLARE @paymentType varchar(50) = 'Master';
DECLARE @reservationID1 INT;
DECLARE @hotelID123 int = 1
DECLARE @locationID2 int = 1
DECLARE @customerStreet2 varchar(50) = 'Marina Square Campus'
DECLARE @customerPostal varchar(50) = 938113
DECLARE @customerUnitNo varchar(50) = '10-501'
DECLARE @bookingStartDate1 date = '2023-06-18'
DECLARE @bookingEndDate1 date = '2023-06-25'

-- Table value parameter for AdvertisedPackages, in order to send it in as a readonly list
DECLARE @bookedServices1 dbo.bookingReservedItems;
INSERT INTO @bookedServices1 (advertisedPackageID, quantity, startDate, endDate)
VALUES (1, 1, '2023-06-18', '2023-06-25'),
(1,2,'2023-06-19','2023-06-30')
;

-- Table value parameter for Customer Guest, using TVP to send it in as a readonly list
DECLARE @customerGuestList1 dbo.customerGuestList;
INSERT INTO @customerGuestList1 (guestName, guestDOB, guestUnitNo, guestStreet , guestPostalCode,tellNo, guestLocationID, guestEmail)
VALUES ('Guest 1', '1998-12-10', '10-111', 'Joo Koon Ave 1', 61821, 9812718,1,'guest1@example.com'),
       ('Guest 2', '1997-02-12', '09-123', 'Pasir ris Ave 3',61341, 8491381,1, 'guest2@example.com');


-- Executing makeReservation
EXEC usp_makeReservation
    @customerName = @customerName1,
	@customerDob = @customerDob1,
    @unitNo = @customerUnitNo,
	@street = @customerStreet2,
	@postalCode = @customerPostal,
	@locationID = @locationID2,
    @tellNo = @tellNo1,
    @email = @email1,
	@bookingStartDate = @bookingStartDate1,
	@bookingEndDate = @bookingEndDate1,
    @payment1 = @paymentType,
    @bookedServices = @bookedServices1,
    @customerGuestList = @customerGuestList1,
	@hotelID = @HotelID123,
	@reservationID = @reservationID1 OUTPUT
	;

-- For testing purposes, For out parameter.
SELECT @reservationID1 AS LatestReservationID;
SELECT @bookingStartDate1 AS TESTDATE;
SELECT * from Reservation;
SELECT * from Booking;
SELECT * from Guest;
SELECT * from Customer;
SELECT * from AdvertisedPackage;
SELECT * from FacilityType;
SELECT * from ServiceItem;
SELECT * from AdvertisedService;


