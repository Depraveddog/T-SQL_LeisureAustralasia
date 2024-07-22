-- Creating the tables first with adding constraints, and lastly populating the data.
-- Take note that since we have alot of FK constraints, some of the constraints will be left empty as 
-- for data integrity and the default will be NO ACTION
-- creating table for capacity
create table Capacity(
capacityID INT primary key,
name varchar(50) not null,
size INT not null);

-- creating table for location
create table Location (
locationID INT IDENTITY(1,1) PRIMARY KEY,
city varchar(50) not null,
country varchar(50) not null,
);

-- creating table for Hotel address 
create table HotelAddress(
hotelAddressID INT primary key,
unitNo varchar(50) not null,
street varchar(50) not null,
postalCode varchar(50) not null,
locationID int
);
Alter table HotelAddress
add constraint FK_HotelAddress_Location foreign key (locationID) references Location(locationID)

-- creating table for hotel and adding FK constraints
create TABLE Hotel(
hotelID INT Primary key not null
, name VARCHAR(50) not null,
description varchar(500) null,
tellNo varchar(50) not null,
hotelAddressID INT not null,
capacityID int not null
);

Alter table Hotel
add constraint FK_Hotel_HotelAddress foreign key (hotelAddressID) references HotelAddress(hotelAddressID)

Alter table Hotel
add constraint FK_Hotel_Capacity foreign key (capacityID) references Capacity(capacityID)
on update cascade

-- creating table for department and adding FK constraints
create table Department(
departmentID INT primary key,
name varchar(50) not null,
area varchar(150) not null);

-- creating table for employee address and adding FK constraints
create table EmployeeAddress(
employeeAddressID INT primary key,
unitNo varchar(50) not null,
street varchar(50) not null,
postalCode varchar(50) not null,
locationID int not null
);
Alter table EmployeeAddress
add constraint FK_EmployeeAddress_Location foreign key (locationID) references Location(locationID)

-- creating table for employee and adding FK constraints
create table Employee(
employeeID  INT IDENTITY(1,1) PRIMARY KEY,
name varchar(50) not null,
dob date,
tellNo varchar(50) not null,
employeeAddressID INT not null,
hotelID INT not null,
departmentID INT not null);

Alter table Employee
add constraint FK_Employee_Address foreign key (employeeAddressID) references EmployeeAddress(employeeAddressID)

Alter table Employee
add constraint FK_Employee_Department foreign key (departmentID) references Department(departmentID)
on update cascade

Alter table Employee
add constraint FK_Employee_Hotel foreign key (hotelID) references Hotel(hotelID)
on update cascade

-- creating table for manager and adding FK constraints
create table Manager(
managerID  INT IDENTITY(1,1) PRIMARY KEY,
employeeID INT unique);

Alter table Manager
add constraint FK_Manager_Employee foreign key (employeeID) references Employee(employeeID)
on update cascade
on delete cascade

-- creating table for headOffice and adding FK constraints
create table HeadOffice
(
headOfficeID int primary key,
tellNo varchar(50) ,
departmentID INT not null);

Alter table HeadOffice
add constraint FK_HeadOffice_Department foreign key (departmentID) references Department(departmentID)
on update cascade 

-- creating table for facility and adding FK constraints
create table Facility(
facilityID INT primary key,
name varchar(50) not null,
description varchar(500) null,
statusCode varchar(20) null,
hotelID INT not null);

Alter table Facility
add constraint FK_Facility_Hotel foreign key (hotelID) references Hotel(hotelID)
on update cascade

-- creating table for facilityType and adding FK constraints
create table FacilityType(
facilityTypeID int primary key,
name varchar(50) not null,
description varchar(500) null,
quantity INT not null,
capacityID INT not null,
facilityID INT not null);

Alter table FacilityType
add constraint FK_FacilityType_Capacity foreign key (capacityID) references Capacity(capacityID)

Alter table FacilityType
add constraint FK_FacilityType_Facility foreign key (facilityID) references Facility(facilityID)
on update cascade
on delete cascade

-- creating table for serviceCategory and adding FK constraints
create table ServiceCategory(
serviceCatID INT primary key,
name varchar(50) not null,
description varchar (500) null,
serviceType varchar (50) not null,
hotelID int not null
);
Alter table ServiceCategory
add constraint FK_ServiceCategory_Hotel foreign key (hotelID) references Hotel(hotelID)
on update cascade
on delete cascade

-- creating table for base currency and adding FK constraints
create table BaseCurrency(
currencySymbol varchar(10) primary Key,
name varchar(50) not null);

-- creating table for service item and adding FK constraints
create table ServiceItem(
serviceItemID INT IDENTITY(1,1) PRIMARY KEY,
name varchar (50) not null,
description varchar (500) null,
restriction varchar (200) null,
note varchar (200) null,
comment varchar (250) null,
availableTime varchar(200),
quantity int not null,
baseCost decimal not null,
statusCode VARCHAR(20),
baseCurrency varchar(10) not null,
capacityID INT not null,
facilityTypeID INT null,
serviceCatID INT
);
Alter table ServiceItem
add constraint FK_ServiceItem_FacilityType foreign key (facilityTypeID) references FacilityType(facilityTypeID)
on update cascade
on delete cascade

Alter table ServiceItem
add constraint FK_ServiceItem_BaseCurrency foreign key (baseCurrency) references BaseCurrency(currencySymbol)

Alter table ServiceItem
add constraint FK_ServiceItem_ServiceCategory foreign key (serviceCatID) references ServiceCategory(serviceCatID)

Alter table ServiceItem
add constraint FK_ServiceItem_Capacity foreign key (capacityID) references Capacity(capacityID)

-- creating table for AdvertisedPackage and adding FK constraints
create table AdvertisedPackage(
adPackID INT IDENTITY(1,1) PRIMARY KEY,
name varchar (50) not null,
description varchar(50) null,
price decimal (10,2) not null,
inclusion varchar(250) null,
exclusion varchar(250) null,
startDate date not null,
endDate date not null,
statusCode varchar(20) not null,
employeeID int not null,
currencySymbol varchar(10) not null);

Alter table AdvertisedPackage
add constraint FK_AdvertisedPackage_Employee foreign key (employeeID) references Employee(employeeID)
ON UPDATE NO ACTION
ON DELETE NO ACTION
Alter table AdvertisedPackage
add constraint FK_AdvertisedPackage_BaseCurrency foreign key (currencySymbol) references BaseCurrency(currencySymbol)


-- creating a composite FK primary key table as we want to be able to identify what services in advertisedpackage as one advertisedpackage has many services
create table AdvertisedService(
adPackID INT,
serviceItemID INT,
quantity int not null,
primary key ( adPackID, serviceItemID));

alter table AdvertisedService
add constraint FK_AdvertisedService_AdvertisedPackage foreign key (adPackID) references AdvertisedPackage(adPackID)
ON UPDATE CASCADE
ON DELETE CASCADE
alter table AdvertisedService
add constraint FK_AdvertisedService_ServiceItem foreign key (serviceItemID) references ServiceItem (serviceItemID)
ON UPDATE CASCADE
ON DELETE CASCADE

-- creating a table for grace period and adding constraint as we are able to references to which advertisedpackage
create table GracePeriod (
gracePeriodID int primary key,
durationDays varchar(50) not null,
adPackID int not null
);

Alter table GracePeriod
add constraint FK_GracePeriod_AdvertisedPackage foreign key (adPackID) references AdvertisedPackage(adPackID)
ON UPDATE CASCADE
ON DELETE CASCADE

-- creating table for customer guest address and adding FK constraints
create table CustomerGuestAddress(
customerAddressID INT IDENTITY(1,1) primary key,
unitNo varchar(50) not null,
street varchar(50) not null,
postalCode varchar(50) not null,
locationID int not null
);

Alter table CustomerGuestAddress
add constraint FK_CustomerGuestAddress_Location foreign key (locationID) references Location (locationID)

-- creating table for customer and adding FK constraints
create table Customer(
customerID INT IDENTITY(1,1) PRIMARY KEY,
name varchar (50) not null,
DOB date  not null,
tellNo varchar(50)  not null,
email varchar (50) not null,
customerAddressID int not null);

Alter table Customer
add constraint FK_Customer_CustomerGuestAddress foreign key (customerAddressID) references CustomerGuestAddress(customerAddressID)
ON UPDATE CASCADE
ON DELETE NO ACTION

-- creating table for reservation and adding FK constraints
create table Reservation(
reservationID INT IDENTITY(1,1) PRIMARY KEY,
payment varchar(50) not null,
deposit varchar(10) not null,
customerID int not null,
hotelID int not null,
employeeID int null
);
Alter table Reservation 
add constraint FK_Reservation_Customer foreign key (customerID) references Customer(customerID)
on update cascade

Alter table Reservation 
add constraint FK_Reservation_Employee foreign key (employeeID) references Employee(employeeID)
on update cascade

Alter table Reservation
add constraint FK_Reservation_Hotel foreign key (hotelID) references Hotel(hotelID)

-- creating table for Guest and adding FK constraints which customer it is associated with
create table Guest(
guestID INT IDENTITY(1,1) PRIMARY KEY,
name varchar (50) not null,
DOB date  not null,
customerID int not null,
tellNo varchar(50) null,
email varchar(50) null,
customerAddressID INT not null,
);

Alter table Guest
add constraint FK_Guest_CustomerGuestAddress foreign key (customerAddressID) references CustomerGuestAddress (customerAddressID)

Alter table Guest
add constraint FK_Guest_Customer foreign key (customerID) references Customer(customerID)
on update cascade
on delete cascade

-- creating table for Booking and adding FK constraints
create table Booking(
bookingID int  IDENTITY(1,1) PRIMARY KEY,
quantity int not null,
startDate date,
endDate date,
reservationID INT not null,
adPackID int not null,
customerID int not null,
facilityTypeID int null
);

Alter table Booking
add constraint FK_Booking_Reservation foreign key (reservationID) references Reservation(reservationID)

Alter table Booking
add constraint FK_Booking_AdvertisedPackage foreign key (adPackID) references AdvertisedPackage(adPackID)

Alter table Booking
add constraint FK_Booking_Customer foreign key (customerID) references Customer(customerID)
on update cascade

Alter table Booking
add constraint FK_Booking_FacilityType foreign key (facilityTypeID) references FacilityType(facilityTypeID)


create table TransactionBilling(
transactionID int primary key,
bookingID int,
adPackID int);


Alter table TransactionBilling
add constraint FK_TransactionBilling_Booking foreign key (bookingID) references Booking(bookingID)

Alter table TransactionBilling
add constraint FK_TransactionBilling_AdvertisedPackage foreign key (adPackID) references AdvertisedPackage(adPackID)

-- creating a table for discount 
create table Discount(
discountID int primary key,
discountPercentage varchar(50) null,
managerID int null,
headOfficeID int null);

Alter table Discount
add constraint FK_Discount_Manager foreign key (managerID) references Manager(managerID)
on update cascade 
on delete no action

Alter table Discount
add constraint FK_Discount_HeadOffice foreign key (headOfficeID) references HeadOffice(headOfficeID)


-- creating a table for billing and referencing to what bookingID it has and the extra charges 
create table Billing(
billingID int primary key,
paymentDate date not null,
paymentmethod varchar(100) not null,
customerID int not null,
transactionID int not null,
reservationID int not null,
discountID int null,

);

Alter table Billing
add constraint FK_Billing_Reservation foreign key (reservationID) references Reservation(reservationID)

Alter table Billing
add constraint FK_Billing_Discount foreign key (discountID) references Discount(discountID)
on update cascade

Alter table Billing
add constraint FK_Billing_Customer foreign key (customerID )references Customer(customerID)

Alter table Billing
add constraint FK_Billing_TransactionBilling foreign key (transactionID)references TransactionBilling(transactionID)



--- Populating Data, take note we tried to populate every table with 5 each but for testing purposes we will only stick with hotel populating
Insert into Capacity(capacityID, name, size) values
(1, 'Small', 2),
(2, 'Medium', 4),
(3, 'Small-Capacity', 100),
(4, 'Medium-Capacity', 500),
(5, 'Large-Capacity', 1000),
(6, 'Hotel-Capacity', 1500);
SELECT * FROM Capacity

Insert into Location(country,city) values
('Singapore', 'Singapore') ,
('Australia', 'Sydney'),
('India','Delhi'),
('Australia', 'Graman'),
('Malaysia', 'Johor');
SELECT * FROM Location

Insert into HotelAddress(hotelAddressID, unitNo, street, postalCode, locationID) values
(1, '01-231', '67 Passage Avenue', 21313, 4),
(2, '02-123', 'Marina Square', 58127, 1),
(3, '01-213', '85 Noalimba Avenue', 123141,2),
(4, '17-123', 'New Delhi St 12', 012931, 3),
(5, '15-123', 'Johor ave 9', 341121, 5)
SELECT * FROM HotelAddress

Insert into Hotel ( hotelID, name, description, tellNo, capacityID, hotelAddressID) values
(1, 'Queen Hotel', '5 star hotel', 95313456, 6, 1),
(2, 'King Hotel', '4 star hotel', 90283184, 6, 2),
(3, 'Joker Hotel', '3 star hotel', 8727138, 6, 3),
(4, 'Knight Hotel', '5 star hotel', 9812371, 6, 4),
(5, 'Citizen Hotel', '4 star hotel', 9128371, 6, 5);
SELECT * FROM Hotel

Insert into Department(departmentID, name, area) values
(1, 'MarketingTeam', 'Marketing'),
(2, 'FacilitiesTeam', 'Facilities'),
(3, 'FoodManagement', 'F&B'),
(4, 'HouseKeepingTeam', 'Housekeeping'),
(5, 'DiscountTeam', 'DiscountManagement')
SELECT * FROM Department

Insert into EmployeeAddress(employeeAddressID,unitNo, street, postalCode, locationID) values
(1, '05-10', 'Choa Chua Kang Crescent', 68210, 1),
(2, '09-11', 'Sydney street 10', 12931, 2),
(3, '10-406', 'New Delhi ave 11', 20984, 3),
(4, '11-120', 'Woodlands Ave 12', 61821, 2),
(5, '17-140', 'Kranji St 08', 612818, 2);
SELECT * FROM EmployeeAddress

Insert into Employee(name, tellNo, dob, employeeAddressID, hotelID, departmentID) values
('Chan Wai Leng', 9271731, '1999-12-10', 1, 2, 1),
('Victor Chua', 98127823, '1997-11-10', 2, 1, 3),
('Sander Fabian', 9182731, '1996-11-18'	, 3, 3, 2),
('Gina Lee', 96982171, '1995-11-10', 4, 4,4),
('Girvin Chua', 9182472, '1994-06-10',5,5,5)
SELECT * FROM Employee

Insert into Manager(employeeID) values
(3),(2),(1);
SELECT * FROM Manager

Insert into HeadOffice(headOfficeID, tellNo, departmentID) values
(1, 9812131, 1),
(2, 9845511, 2),
(3, 8172318, 3),
(4, 8247192, 4),
(5, 8912831, 5);
SELECT * From HeadOffice

Insert into Facility(facilityID, name, description, statusCode, hotelID) values
(1, 'Swimming Pool', 'Swimming pools with different sizes', 'Active', 1),
(2, 'Gym', 'Gym equipments for gymers', 'InActive', 2),
(3, 'Rooms', 'Rooms for guests', 'Active', 3),
(4, 'BallRoom', 'Venue for many purposes','Active',4),
(5, 'HallRoom', 'Venue for weddings', 'Active',5);
SELECT * From Facility

Insert into FacilityType(facilityTypeID, name, description, capacityID, facilityID, quantity) values
(1, 'Swimming Pool for kids', 'Pools suitable for kids!', 3, 1, 1),
(2, 'Gym Spa room', 'Spa-ing after a good session in the gym', 3, 2, 5),
(3, 'Couple suite room', 'Nice room for couples', 1, 3, 200),
(4, 'Ballroom for Restaurants', ' a good room for serving',4, 4, 1),
(5, 'Wedding Hall Room', 'a room catered for weddings', 5, 5, 1);
SELECT * FROM FacilityType

Insert into BaseCurrency( currencySymbol, name) values
('SGD', 'Singapore Dollar'),
('AUD', 'Australian Dollar'),
('RM', 'Malaysian Dollar'),
('USD', 'United State Dollar'),
('YEN', 'Japan Dollar'),
('INR', 'Indian Rupee')
;
Select * FROM BaseCurrency
Insert into ServiceCategory( serviceCatID, name , description, serviceType, hotelID) values
(1, 'Accomodation', 'For guest enjoyment purposes', 'Accomodation', 1),
(2, 'Accomodation', 'For guest enjoyment purposes', 'Accomodation', 2),
(3, 'Accomodation', 'For guest enjoyment purposes', 'Accomodation', 3),
(4, 'Accomodation', 'For guest enjoyment purposes', 'Accomodation', 4),
(5, 'Accomodation', 'For guest enjoyment purposes', 'Accomodation', 5),
(6, 'Event', 'For special events', 'Events', 1),
(7, 'Event', 'For special events', 'Events', 2),
(8, 'Event', 'For special events', 'Events', 3),
(9, 'Event', 'For special events', 'Events', 4),
(10, 'Event', 'For special events', 'Events', 5);
SELECT * FROM ServiceCategory

Insert into ServiceItem( name, description, restriction, note, comment, availableTime, quantity, baseCost, statusCode, baseCurrency, capacityID, facilityTypeID, serviceCatID) values
('Food services', 'Serving Food', 'Restriction 1','Note','comment', '9:00 AM - 5:00 PM', 250,  2000, 'Active','AUD',3, 1, 6),
('Music services', 'Concert','Restriction1', 'Note2', 'comment', '10:00 - 5:30 PM', 100, 750, 'Active', 'AUD',3, 2,6),
('Entertainment services', 'Movie Showtime','Restriction3','Note3', 'comment' ,'10:00 AM - 2:00 PM', 150, 300, 'InActive','AUD', 3, 3, 6),
('Couple room services', 'Rental for couples', 'Restriction4', 'Note4', 'comment4', '10:00 AM - 10:00 AM',  75, 30000, 'Active', 'AUD', 1,3,1),
('Family room services', 'Rental for family', 'Restriction5', 'Note5',  'comment5', '08:00 AM - 12:00PM', 75 , 45000, 'Active', 'AUD', 2,3,1),
('Wedding services', 'Catering to wedding', 'Restriction6', 'Note6', 'comment6', '1:00PM - 10:00 PM', 2, 15000, 'InActive', 'AUD', 5, 5, 6)
SELECT * FROM ServiceItem
Insert into AdvertisedPackage (name, description, price, currencySymbol, exclusion, inclusion, startDate, endDate, statusCode, employeeID) values
('Package1', 'Family bundle', 500, 'AUD', 'No buffet', 'Free usage of pool', '2023-06-15', '2023-06-20', 'Active', 1),
('Package2', 'Couple bundle', 350, 'AUD', 'No pool', 'Free buffet', '2023-06-18', '2023-06-25', 'Active', 2),
('Package3', 'Friend bundle', 300, 'AUD', 'No gym', 'Free taxis', '2023-07-19', '2023-07-25', 'InActive', 1),
('Wedding Package', 'Wedding bundle', 20000, 'AUD', 'No gym', 'Free stay for a week', '2023-07-20', '2023-07-25', 'InActive', 3);

Insert into AdvertisedService(adPackID,serviceItemID, quantity) values
(1,1,2),
(1,2, 1),
(1,5, 1);
SELECT * from AdvertisedService;

Insert into GracePeriod(gracePeriodID, durationDays, adPackID) values
(1, '1 week', 1),
(2,'2 week', 2),
(3, '3 week', 3),
(4, '4 week', 4);
SELECT * from GracePeriod;

Insert into CustomerGuestAddress( unitNo, street ,postalCode, locationID) values
('09-10', 'Bukit Batok Ave 1', '674812', 1),
('05-19', 'Commonwealth Ave 9', '93182', 1),
('03-12', 'Clementi St 90', '19283', 1),
('02-20', 'Chinese Garden St 99', '19281', 1);
SELECT * FROM CustomerGuestAddress

Insert into Customer(name,DOB, tellNo, email, customerAddressID) values
('Carol', '1999-12-10', 8317317 ,'Carol@gmail.com', 1),
('Lebron', '1979-12-10',8418912, 'Lebron@gmail.com', 2),
('Larry', '1989-11-05',9813881, 'larry@gmail.com',3),
('Crystal', '1998-07-05',918281, 'crystal@gmail.com',4);
SELECT * FROM Customer

Insert into Reservation( payment, deposit, customerID, hotelID, employeeID) values
('Visa', '250', 1, 1, 1),
('Master', '80', 2, 1, 1),
('GrabPay', '100', 3, 1, 2),
('UOB', '600', 4, 1, 3);
Select * from Reservation

Insert into Guest(name,DOB,tellNo,customerID,email,customerAddressID) values
('Gabriel','1999-12-10',8271722, 2, 'gabriel@gmail.com', 3),
('Sabrina','1999-11-10', 8399138,3, 'sabrina@gmail.com', 2),
('Rita', '1997-11-07', 89139104, 4, 'rita@gmail.com',4);

Insert into Booking(quantity,startDate, endDate,adPackID,customerID,reservationID,facilityTypeID) values
(2,'2023-06-18','2023-06-20',3, 2,2, 1),
(2,'2023-06-18','2023-06-20',2, 3,3, 4),
(1,'2023-06-18','2023-06-20',1,1,1, 3);
SELECT * from booking 

Insert into TransactionBilling(transactionID,bookingID,adPackID) values
(1,1,1),
(2,1,2),
(3,1,3);
select * from TransactionBilling

Insert into Discount(discountID, discountPercentage, managerID, headOfficeID) values
(1, '10%', 3, null),
(2, '20%', 3, null),
(3, '25%', null, 5),
(4, '30%', null, 5),
(5, '35%', null, 5);
select * from Discount

Insert into Billing(billingID, paymentDate, paymentmethod, customerID, reservationID ,transactionID, discountID)
values
(1, '2023-06-18', 'Visa', 1, 1, 1, null),
(2, '2023-06-18', 'Master', 2, 1, 1, 1),
(3, '2023-05-18', 'UOB', 3, 3, 1, 2);
Select * from Billing



