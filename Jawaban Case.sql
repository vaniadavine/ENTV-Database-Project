-- CASE ANSWER

USE ENTV

/*
NO 1
Display StaffID, StaffName, VendorName, and Total Transaction (Obtained from counting the purchase transaction) 
for every transaction happens later than August and StaffName starts with letter 'B’.
*/
SELECT 
	ms.StaffID, StaffName, VendorName, 
	COUNT(PurchaseID) AS [Total Transaction]
FROM 
	MsStaff ms, MsVendor mv, PurchaseHeader ph
WHERE
	ms.StaffID = ph.StaffID AND ph.VendorID = mv.VendorID 
	AND MONTH(ph.PurchaseDate)>8 
	AND LEFT(StaffName,1) = 'B'
GROUP BY ms.StaffID,StaffName, VendorName

/*
NO 2
Display CustomerID (obtained by last 3 characters), CustomerName, and Total Spending 
(obtained from sum of all TelevisionPrice times Quantity) 
for every CustomerName contains letter 'a' and TelevisionName contains 'LED'.
*/
SELECT 
	RIGHT (mc.CustomerID, 3) AS "CustomerID", CustomerName, 
	[Total Spending] = SUM(mt.TelevisionPrice*sd.SalesQuantity)
FROM 
	MsCustomer mc, SalesHeader sh, SalesDetail sd, MsTelevision mt
WHERE 
	mc.CustomerID = sh.CustomerID 
	AND sh.SalesID = sd.SalesID 
	AND sd.TelevisionID = mt.TelevisionID
	AND CustomerName LIKE '%a%'
	AND TelevisionName LIKE '%LED%'
GROUP BY mc.CustomerID, CustomerName

/*
NO 3
Display StaffName (obtained from the first name of the Staff), TelevisionName, 
and Total Price (obtained from sum of all TelevisionPrice times Quantity)
for every transaction happens more than twice and TelevisionName contains 'UHD'.
*/
SELECT 
	SUBSTRING(ms.StaffName, 1, CHARINDEX(' ', ms.StaffName)) AS [StaffName],
	TelevisionName, SUM(mt.TelevisionPrice*pd.PurchaseQuantity) AS "Total Price"
FROM 
	MsStaff ms, MsTelevision mt, PurchaseHeader ph, PurchaseDetail pd
WHERE 
	ms.StaffID = ph.StaffID 
	AND ph.PurchaseID = pd.PurchaseID 
	AND TelevisionName LIKE '%UHD%' 
GROUP BY 
	ms.StaffName, TelevisionName
HAVING COUNT (ph.PurchaseID) > 2

/*
NO 4
Display TelevisionName (obtained from TelevisionName in upper case format), Max Television Sold 
(obtained from the maximum quantity that has been sold in one transaction end with the word ‘ Pc(s)’), 
Total Television Sold (obtained from sum of the quantity that sold in all transaction end with the word ‘ Pc(s)’) 
for every Television which price is more than 3000000 and sales happens after February, order it by Total Television Sold ascendingly.
*/
SELECT 
	UPPER(TelevisionName) AS TelevisionName, 
	CONCAT(MAX(sd.SalesQuantity), ' Pc(s)') AS "Max Television Sold", 
	CONCAT(SUM(sd.SalesQuantity), ' Pc(s)') AS "Total Television Sold"
FROM 
	MsTelevision mt, SalesDetail sd, SalesHeader sh
WHERE 
	mt.TelevisionID = sd.TelevisionID 
	AND sh.SalesID = sd.SalesID 
	AND TelevisionPrice > 3000000 
	AND MONTH (SalesDate) > 2
GROUP BY TelevisionName
ORDER BY SUM(sd.SalesQuantity) ASC

/*
5.	Display VendorName,VendorPhone (obtained from vendorPhone with ‘+62’ replace by ‘0’), 
TelevisionName, TelevisionPrice (obtained from adding ‘Rp. ’ before TelevisionPrice) 
for every Television which price more than average of all TelevisionPrice and VendorName must be at least 2 words.
(alias subquery) 
*/
SELECT mv.VendorName,
REPLACE(mv.VendorPhoneNumber,'+62','0') AS VendorPhone, mt.TelevisionName,
[TelevisionPrice] = 'Rp. ' +  CONVERT(CHAR,mt.TelevisionPrice)
FROM 
	MsVendor mv 
	JOIN PurchaseHeader ph ON mv.VendorID = ph.VendorID
	JOIN PurchaseDetail pd ON ph.PurchaseID=pd.PurchaseID
	JOIN MsTelevision mt   ON mt.TelevisionID=pd.TelevisionID,
	(
		SELECT
		AVG(TelevisionPrice) AS [AverageOfTelevisionPrice]
		FROM MsTelevision
	)AverageTvPrice
WHERE mv.VendorName LIKE '% %' AND mt.TelevisionPrice > AverageTvPrice.AverageOfTelevisionPrice

/*
6.	Display StaffID, StaffName, StaffEmail (obtained from words before ‘@’), 
and StaffSalary for every StaffSalary more than average of StaffSalary 
and taken care transaction for customer whose name contains ‘o’.
(alias subquery)
*/
SELECT 
	ms.StaffID, ms.StaffName, mc.CustomerName,
	SUBSTRING (StaffEmail,0,CHARINDEX('@',StaffEmail)) AS StaffEmail,
	StaffSalary
FROM 
	MsStaff ms
	JOIN SalesHeader sh ON sh.StaffID = ms.StaffID
	JOIN MsCustomer mc ON mc.CustomerID=sh.CustomerID,
	(
		SELECT AVG(StaffSalary) AS [SalaryAverage]
		FROM MsStaff
	)AverageStaffSalary
WHERE 
	ms.StaffSalary > AverageStaffSalary.SalaryAverage 
	AND EXISTS
	(
		SELECT *
		FROM SalesHeader shs
		JOIN MsCustomer mcs ON shs.CustomerID = mcs.CustomerID
		WHERE mcs.CustomerName LIKE '%o%' AND mc.CustomerID = mcs.CustomerID
	)

/*
7.	Display TelevisionID (obtained from replacing ‘TE’ to ‘Television ’), TelevisionName, 
TelevisionBrand (obtained from TelevisionBrand in upper case format), 
and TotalSold (obtained from the sum of quantity sold to customer end with the word ‘ Pc(s)’) 
for every TelevisionName that contains the word ‘LED’ 
and TotalSold more than average of the total sold of all television , order it by TotalSold ascendingly.
(alias subquery)
*/
SELECT	
	[TelevisionID] = REPLACE(mt.TelevisionID, 'TE', 'Television'),
	mt.TelevisionName,UPPER(mtb.TelevisionBrandName) AS [TelevisionBrand],
	[TotalSold]=CONCAT(SUM(sd.SalesQuantity), ' Pc(S)')
FROM
	MsTelevision mt
	JOIN MsTelevisionBrand mtb ON mt.TelevisionBrandID=mtb.TelevisionBrandID
	JOIN SalesDetail sd ON sd.TelevisionID=mt.TelevisionID,
	(
		SELECT AVG(sd.SalesQuantity) AS [avgg]
		FROM SalesDetail sd
	)avgs
WHERE mt.TelevisionName LIKE '%LED%'
GROUP BY avgs.avgg,mt.TelevisionID,mt.TelevisionName,mtb.TelevisionBrandName
HAVING SUM(sd.SalesQuantity) > avgs.avgg
ORDER BY SUM(sd.SalesQuantity) ASC

/*
8.  (Select)Display VendorName, VendorEmail, VendorPhone (obtained by replacing VendorPhone first character into ‘+62’), 
and Total Quantity (obtained from the sum of quantity purchased and ended with ‘ Pc(s)’) 
for every purchase which television price is higher than the maximum television price in 
every purchase that occurred between the 3th and 6th month of the year and VendorName must at least 2 words.
(alias subquery)
*/
SELECT
	mv.VendorName,mv.VendorEmail,
	CONCAT('+62',SUBSTRING(mv.VendorPhoneNumber,2,LEN(mv.VendorPhoneNumber))) AS VendorPhone,
	CONCAT(SUM(pd.PurchaseQuantity),' Pc(s)') AS [Total Quantity]
FROM 
	MsVendor mv
	JOIN PurchaseHeader ph ON mv.VendorID=ph.VendorID
	JOIN PurchaseDetail pd ON ph.PurchaseID=pd.PurchaseID
	JOIN MsTelevision mt ON mt.TelevisionID=pd.TelevisionID,
	(
		SELECT MAX(mts.TelevisionPrice) AS MaxPrice
		FROM MsTelevision mts
		JOIN PurchaseDetail pds ON pds.TelevisionID=mts.TelevisionID
		JOIN PurchaseHeader phs ON pds.PurchaseID=phs.PurchaseID
		WHERE MONTH(phs.PurchaseDate) BETWEEN 3 AND 6
	)MaxTelevisionPrice
WHERE 
	mt.TelevisionPrice > MaxTelevisionPrice.MaxPrice 
	AND mv.VendorName LIKE '% %'
GROUP BY mv.VendorName,mv.VendorEmail,mv.VendorPhoneNumber

/*
9.  Create a view named ‘CustomerTransaction’ to display CustomerName, CustomerEmail, 
Maximum Quantity Television (obtained from the maximum quantity sold and ended with ‘ Pc(s)’), 
and Minimum Quantity Television (obtained from the minimum quantity purchased and ended with ‘ Pc(s)’) 
for every customer whose name contains ‘b’ and the maximum quantity isn’t equal to its minimum quantity.
*/
CREATE VIEW CustomerTransaction AS
SELECT 
	mc.CustomerName,
	mc.CustomerEmail,
	CONCAT(MAX(sd.SalesQuantity), ' Pc(s)') AS [Maximum Quantity Television],
	CONCAT(MIN(sd.SalesQuantity), ' Pc(s)') AS [Minimum Quantity Television]
FROM 
	SalesHeader sh
	JOIN SalesDetail sd ON sh.SalesID = sd.SalesID
	JOIN MsCustomer mc ON sh.CustomerID = mc.CustomerID
WHERE CustomerName LIKE 'B%' OR CustomerName LIKE '%b%'
GROUP BY CustomerName, CustomerEmail
HAVING MIN(sd.SalesQuantity) != MAX(SalesQuantity)

SELECT * FROM CustomerTransaction

/*
10.	Create a view named 'StaffTransaction' to display StaffName, StaffEmail, StaffPhone, 
Count Transaction (obtained from total number of transaction), and Total Television 
(obtained by total quantity of television purchased) for every transaction 
that the date of transaction happened later than 10th day and staff email ends with '@gmail.com'. 
*/
CREATE VIEW StaffTransaction AS
SELECT 
	ms.StaffName,
	ms.StaffEmail,
	ms.StaffPhoneNumber,
	COUNT(DISTINCT pd.PurchaseID) AS [Count Transaction],
	SUM(DISTINCT pd.PurchaseQuantity) AS [Total Television]
FROM 
	PurchaseHeader ph
	JOIN PurchaseDetail pd ON ph.PurchaseID = pd.PurchaseID
	JOIN MsStaff ms on ph.StaffID = ms.StaffID
WHERE 
	StaffEmail LIKE '%@gmail.com'
	AND DATENAME(day, ph.PurchaseDate) > 10 
GROUP BY StaffName, StaffEmail, StaffPhoneNumber

SELECT * FROM StaffTransaction