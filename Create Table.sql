CREATE DATABASE ENTV
USE ENTV

/*
PROJECT DATABASE LAB
ANGGOTA KELOMPOK :
Rionaldo Alviansa Handoyo - 2440067995
Muhammad Irfansyah - 2440088135
Vania Davine Purwandari - 2440088192
Andi Rozi Syafirah - 2440070863
*/
CREATE TABLE MsStaff(
    StaffID CHAR(5) PRIMARY KEY NOT NULL
    CHECK(StaffID LIKE 'ST[0-9][0-9][0-9]'),
    StaffName VARCHAR(50) NOT NULL,
    StaffEmail VARCHAR(70) NOT NULL
    CHECK(StaffEmail LIKE '%@%.%'),
    StaffGender VARCHAR(10) NOT NULL
    CHECK(StaffGender IN ('Male','Female')),
    StaffPhoneNumber VARCHAR(18) NOT NULL
    CHECK (StaffPhoneNumber LIKE '+62%'),
    StaffAddress VARCHAR(250) NOT NULL,
    StaffSalary INT NOT NULL,
    StaffDOB DATE NOT NULL
    CHECK(YEAR(StaffDOB)<=2000)
)

CREATE TABLE MsCustomer(
    CustomerID CHAR(5) PRIMARY KEY NOT NULL
    CHECK(CustomerID LIKE 'CU[0-9][0-9][0-9]'),
    CustomerName VARCHAR(50) NOT NULL,
    CustomerEmail VARCHAR(70) NOT NULL
    CHECK(CustomerEmail LIKE '%@yahoo.com'OR CustomerEmail LIKE '%@gmail.com'),
    CustomerGender VARCHAR(10) NOT NULL
    CHECK(CustomerGender IN('Male','Female')),
    CustomerPhoneNumber VARCHAR(18) NOT NULL
    CHECK(CustomerPhoneNumber LIKE '+62%'),
    CustomerAddress VARCHAR(250) NOT NULL,
    CustomerDOB DATE NOT NULL
)

CREATE TABLE MsVendor(
    VendorID CHAR(5) PRIMARY KEY NOT NULL
    CHECK(VendorID LIKE 'VE[0-9][0-9][0-9]'),
    VendorName VARCHAR(70) NOT NULL
    CHECK (LEN(VendorName)>3),
    VendorPhoneNumber VARCHAR(18)NOT NULL,
    VendorEmail VARCHAR(50)NOT NULL,
    VendorAddress VARCHAR(250)NOT NULL
)

CREATE TABLE MsTelevisionBrand(
    TelevisionBrandID CHAR(5) PRIMARY KEY NOT NULL
    CHECK (TelevisionBrandID LIKE 'TB[0-9][0-9][0-9]'),
    TelevisionBrandName VARCHAR(50) NOT NULL
)

CREATE TABLE MsTelevision(
    TelevisionID CHAR(5) PRIMARY KEY NOT NULL
    CHECK (TelevisionID LIKE 'TE[0-9][0-9][0-9]'),
    TelevisionName VARCHAR(50) NOT NULL,
    TelevisionBrandID CHAR(5)
    FOREIGN KEY REFERENCES MsTelevisionBrand(TelevisionBrandID) 
    ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    TelevisionPrice INT NOT NULL
	CHECK (TelevisionPrice > 1000000 AND TelevisionPrice < 20000000)
)

CREATE TABLE PurchaseHeader(
    PurchaseID CHAR(5) PRIMARY KEY NOT NULL
    CHECK(PurchaseID LIKE 'PE[0-9][0-9][0-9]'),
    StaffID CHAR(5) 
    FOREIGN KEY REFERENCES MsStaff(StaffID)
    ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    VendorID CHAR(5) 
    FOREIGN KEY REFERENCES MsVendor(VendorID)
    ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    PurchaseDate DATE NOT NULL
)

CREATE TABLE PurchaseDetail(
    PurchaseID CHAR(5)
    FOREIGN KEY REFERENCES PurchaseHeader(PurchaseID)
    ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    TelevisionID CHAR(5)
    FOREIGN KEY REFERENCES MsTelevision(TelevisionID)
    ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    PurchaseQuantity INT NOT NULL
)

CREATE TABLE SalesHeader(
    SalesID CHAR(5) PRIMARY KEY NOT NULL
    CHECK(SalesID LIKE 'SA[0-9][0-9][0-9]'),
    StaffID CHAR(5) 
    FOREIGN KEY REFERENCES MsStaff(StaffID)
    ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    CustomerID CHAR(5) 
    FOREIGN KEY REFERENCES MsCustomer(CustomerID)
    ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    SalesDate DATE NOT NULL
)

CREATE TABLE SalesDetail(
    SalesID CHAR(5)
    FOREIGN KEY REFERENCES SalesHeader(SalesID)
    ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    TelevisionID CHAR(5)
    FOREIGN KEY REFERENCES MsTelevision(TelevisionID)
    ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    SalesQuantity INT NOT NULL
)