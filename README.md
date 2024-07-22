In this program, We have designed the EER diagram to fit the requirement given to us.
Following which, We have mapped and normalised the diagram to a relational schema.
After We have created the relational schema, We implemented the tables in SSMS.
Once the table is created, We have implement stored procedures to take in tables as a parameter using TVP.
The stored procedures are:
usp_Createpackage: The functionality is to create a service package. Input needed are: package name, service items (TVP), description, start date, end date, advertised price, advertised currency, and employee.
usp_MakeReservations: The functionality is to make a reservation to ensure that reservation does not exceed the hotel capacity and if so, it will indicate an error. Input needed are: customer details, list of services/packages, and guest lists.
(Test data included)
