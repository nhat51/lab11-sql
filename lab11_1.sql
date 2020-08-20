CREATE DATABASE LAB13
USE Northwind
SELECT *  INTO LAB13.dbo.Custmer FROM dbo.Customers
SELECT * INTO LAB13.dbo.Orders FROM dbo.Orders
SELECT * INTO LAB13.dbo.Products FROM dbo.Products
USE LAB13
-----------
CREATE TRIGGER checkCustomerOnInsert 
ON Custmer 
FOR INSERT
AS
BEGIN 
	IF EXISTS(SELECT Phone FROM inserted WHERE Phone IS NULL)
	BEGIN
		PRINT N'Chưa có số điện thoại'
		ROLLBACK TRANSACTION
	END
END
INSERT INTO Custmer(CustomerID,CompanyName,Phone) VALUES ('WW','CTY212 HCM',NULL)

DROP TRIGGER checkCustomerOnInsert
------------------
CREATE TRIGGER checkCustomerContryOnUpdate
ON Custmer 
FOR UPDATE
AS
BEGIN 
	IF EXISTS(SELECT Country FROM Custmer WHERE Country = 'France')
	BEGIN 
		PRINT N'Không thể thay đổi thông tin ở nước France'
		ROLLBACK TRANSACTION
	END
END
DROP TRIGGER checkCustomerContryOnUpdate
UPDATE Custmer SET Country = 'France' WHERE Country = 'USA'
----------------
UPDATE Custmer SET Active = '1' 
-----------------
CREATE TRIGGER checkCustomerInsteadOfDelete
ON Custmer
FOR DELETE 
AS 
BEGIN
	BEGIN
		PRINT N'unactive'
		ROLLBACK TRANSACTION
		UPDATE Custmer SET Active = '0'  WHERE CustomerID IN (SELECT CustomerID FROM deleted )
		END 
END
DROP TRIGGER checkCustomerInsteadOfDelete
----------------------------

--------------
DELETE FROM Custmer WHERE CustomerID = 'BERGS'
INSERT Custmer(CustomerID,CompanyName,Phone) VALUES('zxcv','abcila','018391020')
INSERT Custmer(CustomerID,CompanyName,Phone) VALUES('qwert','dachcas','12922013')
INSERT Custmer(CustomerID,CompanyName,Phone) VALUES('asdf','ghscjca','56731')
SELECT * FROM Custmer	
GO
sp_settriggerorder @triggername= 'Custmer.checkCustomerContryOnUpdate', @order='First', @stmttype = 'UPDATE';  
CREATE TRIGGER Safety ON