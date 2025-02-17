﻿USE master
GO

DROP DATABASE IF EXISTS ShradhaGeneralBookStores
CREATE DATABASE ShradhaGeneralBookStores
GO

USE ShradhaGeneralBookStores
GO

--Account Start
DROP TABLE IF EXISTS Role
CREATE TABLE Role (
  Id INT PRIMARY KEY IDENTITY,
  Name NVARCHAR(50) NOT NULL,
  CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
  UpdatedAt DATETIME NOT NULL DEFAULT GETDATE()
)
GO

DROP TABLE IF EXISTS Account
CREATE TABLE Account (
  Id INT PRIMARY KEY IDENTITY,
  Email VARCHAR(200) UNIQUE NOT NULL, 
  Password VARCHAR(100) NOT NULL,
  FirstName NVARCHAR(50),
  LastName NVARCHAR(50),
  Phone VARCHAR(20),
  Avatar VARCHAR(100),
  Status BIT DEFAULT 1,
  SecurityCode VARCHAR(50),
  CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
  UpdatedAt DATETIME NOT NULL DEFAULT GETDATE()
)
GO

--Bảng nhiều nhiều
DROP TABLE IF EXISTS AccountRole
CREATE TABLE AccountRole (
  AccountId INT NOT NULL,
  RoleId INT NOT NULL,
  CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
  UpdatedAt DATETIME NOT NULL DEFAULT GETDATE()
  PRIMARY KEY (AccountId, RoleId),
  FOREIGN KEY (AccountId) REFERENCES Account(Id),
  FOREIGN KEY (RoleId) REFERENCES Role(Id),
)
GO


DROP TABLE IF EXISTS [AddressProfile]
CREATE TABLE [AddressProfile] (
	Id INT PRIMARY KEY IDENTITY,
	AccountId INT NOT NULL,
	Street NVARCHAR(200) NOT NULL,
	District NVARCHAR(200) NOT NULL,
	City NVARCHAR(200) NOT NULl,
	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	UpdatedAt DATETIME NOT NULL DEFAULT GETDATE()
	FOREIGN KEY (AccountId) REFERENCES Account(Id),
)
GO


DROP TABLE IF EXISTS Invoice
CREATE TABLE Invoice(
	Id INT IDENTITY(1,1),
	InvoiceNumber INT NOT NULL,
	Payment VARCHAR(100),
	AccountId INT NOT NULL,
	Status BIT NOT NULL,
	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	FOREIGN KEY (AccountId) REFERENCES Account(Id)
)
GO
--Account End

--1 cuốn sách mua nhiều cuốn ( >= 10 cuốn)
--Coupons Start 
DROP TABLE IF EXISTS Voucher
CREATE TABLE Voucher ( -- Theo so tien [FIXED]
	Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(200) UNIQUE NOT NULL,
	VarityCode VARCHAR(10) UNIQUE NOT NULL, 
	Discount INT NOT NULL,
	Condition INT NOT NULL, 
	Quantity INT NOT NULL,
	TimeStart DATETIME NOT NULL DEFAULT GETDATE(),
	TimeEnd DATETIME NOT NULL,
	Status BIT NOT NULL DEFAULT 1, 
 	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	UpdatedAt DATETIME NOT NULL DEFAULT GETDATE(),
)
GO

DROP TABLE IF EXISTS VoucherAccount
CREATE TABLE VoucherAccount 
( -- Theo so tien [FIXED]
	AccountId INT NOT NULL,
	VoucherId INT NOT NULL,
	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	UpdatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	PRIMARY KEY(AccountId,VoucherId),
	FOREIGN KEY (AccountId) REFERENCES Account(Id),
	FOREIGN KEY (VoucherId) REFERENCES Voucher(Id)

)
GO
--Coupons End

--Category Start ( Liên quan đến book)
-- Thể loại ( Nhiều - Nhiều) 
DROP TABLE IF EXISTS Category 
CREATE TABLE Category (
  Id INT PRIMARY KEY IDENTITY,
  Name NVARCHAR(100) NOT NULL,
  ParentId INT,
  CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
  UpdatedAt DATETIME NOT NULL DEFAULT GETDATE(),
  FOREIGN KEY (ParentId) REFERENCES Category(Id)
)
GO

--Tác giả ( Nhiều - Nhiều)
DROP TABLE IF EXISTS Author
CREATE TABLE Author (
  Id INT PRIMARY KEY IDENTITY,
  Name NVARCHAR(100) NOT NULL,
  Biography NTEXT,
  YearOfBirth VARCHAR(5),
  CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
  UpdatedAt DATETIME NOT NULL DEFAULT GETDATE()
)
GO
--Nhà sản xuất ( 1 - Nhiều)
DROP TABLE IF EXISTS Publisher
CREATE TABLE Publisher (
  Id INT PRIMARY KEY IDENTITY,
  Name NVARCHAR(100) NOT NULL,
  NameShort NVARCHAR(10) NOT NULL,
  [Location] NVARCHAR(1000),
  ContactNumber NVARCHAR(100),
  CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
  UpdatedAt DATETIME NOT NULL DEFAULT GETDATE()
)
GO
--Category End


--PRODUCT START
DROP TABLE IF EXISTS Product
CREATE TABLE Product (
  Id INT PRIMARY KEY IDENTITY,
  Name NVARCHAR(200) NOT NULL,
  Description NTEXT,
  Quantity INT NOT NULL,
  Price INT NOT NULL, -- Giá nhập
  Cost INT NOT NULL, -- Giá bán ra
  PublisherId INT NULL,
  [Status] BIT NOT NULL,
  [Hot] BIT NOT NULL ,
  PublishingYear VARCHAR(10) NULL,
  CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
  UpdatedAt DATETIME NOT NULL DEFAULT GETDATE()
  FOREIGN KEY (PublisherId) REFERENCES Publisher(Id),
)
GO

DROP TABLE IF EXISTS ProductImage
CREATE TABLE ProductImage (
  Id INT PRIMARY KEY IDENTITY,
  ProductId INT NOT NULL,
  ImagePath VARCHAR(500) NOT NULL,
  CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
  UpdatedAt DATETIME NOT NULL DEFAULT GETDATE()
  FOREIGN KEY (ProductId) REFERENCES Product(Id)
)
GO
--PRODUCT END

--Review START
DROP TABLE IF EXISTS Review
CREATE TABLE Review (
	Id INT PRIMARY KEY IDENTITY,
	AccountId INT NOT NULL,
	ProductId INT NOT NULL,
	Content TEXT,
	Rating TINYINT NOT NULL,
	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	UpdatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	FOREIGN KEY (AccountId) REFERENCES Account(Id),
	FOREIGN KEY (ProductId) REFERENCES Product(Id)
)
GO
--Review END

--Event Start
DROP TABLE IF EXISTS Event
CREATE TABLE Event (
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(200) NOT NULL,
	Photo VARCHAR(200) NOT NULL,
 	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	UpdatedAt DATETIME NOT NULL DEFAULT GETDATE(),
)
GO

DROP TABLE IF EXISTS EventDetail
CREATE TABLE EventDetail (
	ProductId INT NOT NULL,
	EventId INT NOT NULL,
	Price INT NOT NULL,-- Giá bán ra đã giảm
	LimitedQuantity INT NOT NULL, -- Số lượng giới hạn giảm giá
 	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	UpdatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	PRIMARY KEY(ProductId,EventId),
	FOREIGN KEY (ProductId) REFERENCES Product(Id),
	FOREIGN KEY (EventId) REFERENCES Event(Id)
)
GO
--Event End

--Order Start 
DROP TABLE IF EXISTS OrderStatus
CREATE TABLE OrderStatus (
  Id INT PRIMARY KEY IDENTITY,
  Name VARCHAR(100) NOT NULL,
  CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
  UpdatedAt DATETIME NOT NULL DEFAULT GETDATE(),	
)
GO

DROP TABLE IF EXISTS PaymentMethod
CREATE TABLE PaymentMethod (
	Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(100) NOT NULL,
	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	UpdatedAt DATETIME NOT NULL DEFAULT GETDATE()
)
GO

DROP TABLE IF EXISTS Orders
CREATE TABLE Orders (
  Id INT PRIMARY KEY IDENTITY,
  AccountId INT NOT NULL,
  TotalPrice DECIMAL(18,2) NOT NULL,
  StatusId INT NOT NULL,
  AddressId INT NOT NULL,
  VoucherId INT NOT NUll, 
  PaymentMethodId INT NOT NULL,
  CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
  UpdatedAt DATETIME NOT NULL DEFAULT GETDATE(),
  FOREIGN KEY (AccountId) REFERENCES Account(Id),
  FOREIGN KEY (StatusId) REFERENCES OrderStatus(Id),
  FOREIGN KEY (AddressId) REFERENCES [AddressProfile](Id),
  FOREIGN KEY (PaymentMethodId) REFERENCES PaymentMethod(Id),
  FOREIGN KEY (VoucherId) REFERENCES Voucher(Id)
)
GO
DROP TABLE IF EXISTS OrderDetail
CREATE TABLE OrderDetail (
	OrderId INT NOT NULL,
	ProductId INT NOT NULL,
	Quantity INT NOT NULL,
	Price INT NOT NULL,
	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	UpdatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	PRIMARY KEY (OrderId,ProductId),
	FOREIGN KEY (OrderId) REFERENCES Orders(Id),
	FOREIGN KEY (ProductId) REFERENCES Product(Id),
)
GO

--Order End

--Product liên kết nhiều- nhiều start
DROP TABLE IF EXISTS ProductCategory
CREATE TABLE ProductCategory (
	ProductId INT NOT NULL,
	CategoryId INT NOT NULL,
	PRIMARY KEY(ProductId,CategoryId),
 	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	UpdatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	FOREIGN KEY (ProductId) REFERENCES Product(Id),
	FOREIGN KEY (CategoryId) REFERENCES Category(Id),
)
GO
DROP TABLE IF EXISTS ProductAuthor
CREATE TABLE ProductAuthor (
	ProductId INT NOT NULL,
	AuthorId INT NOT NULL,
	PRIMARY KEY(ProductId,AuthorId),
 	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	UpdatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	FOREIGN KEY (ProductId) REFERENCES Product(Id),
	FOREIGN KEY (AuthorId) REFERENCES Author(Id),
)
GO

--Product liên kết nhiều- nhiều end


