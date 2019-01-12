
--BENJAMIN BENOIT
--A8
--CIS320-02
--NOV 5 2018



--1. List the products with a list price greater
-- than the average list price of all products.



SELECT ItemID, Description, ListPrice
FROM PET..Merchandise

WHERE	ListPrice > ( SELECT AVG(ListPrice)
					FROM	PET..Merchandise)

--2.Which merchandise items have an average sale price more than 
--50 percent higher than their average purchase cost?

SELECT A.ItemID, AvgCost AS [AVERAGE COST], AvgSale AS [AVERAGE SALE PRICE]
FROM (SELECT ItemID, AVG((Quantity*Cost)/Quantity) as AvgCost 
		FROM PET..OrderItem 
		GROUP BY ItemID) A INNER JOIN (Select ItemID, AVG((SalePrice*Quantity)/Quantity) AS AvgSale
										FROM pet..SaleItem 
										GROUP BY ItemID) S on A.ItemId=S.ItemId
WHERE AvgSale> 1.5*AvgCost
--3. List the employees and their total merchandise sales expressed as a percentage of total merchandise sales for all employees.
 
SELECT  SA.EmployeeID, LastName, SUM(SalePrice*Quantity) AS TotalSales,
(SUM(SalePrice*Quantity)/(SELECT SUM(SalePrice*Quantity) FROM PET..SaleItem)*100) AS PctSales
FROM PET..Sale SA
RIGHT OUTER JOIN PET..Employee EM ON SA.EmployeeID = EM.EmployeeID
RIGHT OUTER JOIN PET..SaleItem SI ON SA.SaleID = SI.SaleID
GROUP BY SA.EmployeeID, LastName
 --4. On average, which supplier charges the highest shipping cost as a percent of the merchandise order total?
SELECT TOP 1  MO.SupplierID, Name, (AVG(ShippingCost) / SUM(Cost*Quantity))*100 AS PctShipCost
FROM PET..MerchandiseOrder MO
INNER JOIN PET..OrderItem OI ON MO.PONumber = OI.PONumber
INNER JOIN PET..Supplier SU ON MO.SupplierID = SU.SupplierID
GROUP BY MO.SupplierID, Name
ORDER BY PctShipCost DESC
 
--5. Which customer has given us the most total money for animals and merchandise?
SELECT TOP 1 SE.CustomerID, LastName, FirstName, SUM(SI.SalePrice*Quantity) AS MercTotal, SUM(SA.SalePrice) AS AnimalTotal, SUM(SI.SalePrice*Quantity + SA.SalePrice) AS GrandTotal
FROM PET..Sale SE
INNER JOIN PET..Customer CU ON SE.CustomerID = CU.CustomerID
INNER JOIN PET..SaleItem SI ON SE.SaleID = SI.SaleID
INNER JOIN PET..SaleAnimal SA ON SE.SaleID = SA.SaleID
GROUP BY FirstName, LastName, SE.CustomerID
ORDER BY GrandTotal DESC

--6. Which customers who bought more than $100 in merchandise in May also spent more than $50 on merchandise in October?
CREATE VIEW	TEMP_CUST_PURCH_MAY AS
SELECT S.CustomerID, SUM(SI.SALEPRICE*SI.QUANTITY) AS [PURCHASES]
FROM	PET..SaleItem SI INNER JOIN PET..SALE S ON SI.SaleID=S.SaleID
WHERE	MONTH(S.SaleDate) = 5
GROUP BY	S.CustomerID

CREATE VIEW TEMP_CUST_PURCH_OCT AS
SELECT	S.CustomerID, SUM(SI.SALEPRICE*SI.QUANTITY) AS [PURCHASES]
FROM	PET..SaleItem SI INNER JOIN PET..SALE S ON SI.SaleID = S.SaleID
WHERE	MONTH(S.SALEDATE) = 10
GROUP BY	S.CustomerID

SELECT	CPO.CustomerID, C.FirstName, C.LastName, CPM.PURCHASES AS [MAY PURCHASES]
FROM	TEMP_CUST_PURCH_OCT CPO INNER JOIN TEMP_CUST_PURCH_MAY CPM ON CPO.CustomerID=CPM.CustomerID INNER JOIN PET..Customer C ON C.CustomerID=CPM.CustomerID
WHERE	CPM.PURCHASES>100 AND
		CPO.PURCHASES >50

--7. What was the net change in quantity on hand for premium canned dog food between January 1 and July 1?
SELECT Description, ME.ItemID, (SELECT SUM(Quantity) 
								FROM PET..OrderItem O INNER JOIN PET..MerchandiseOrder M ON O.PONumber = M.PONumber
                                WHERE ItemID = (SELECT ItemID 
												FROM PET..Merchandise 
												WHERE Description = 'Dog Food-Can-Premium')AND OrderDate BETWEEN '2004-01-01' AND '2004-06-30') AS Purchased,
                                               (SELECT SUM(Quantity) FROM PET..SaleItem SI INNER JOIN PET..Sale SA ON SA.SaleID = SI.SaleID
                                                WHERE ItemID = (SELECT ItemID
																FROM PET..Merchandise 
																WHERE Description = 'Dog Food-Can-Premium') AND SaleDate BETWEEN '2004-01-01' AND '2004-06-30') AS Sold,
                                                (SELECT SUM(Quantity) 
												 FROM PET..OrderItem O INNER JOIN PET..MerchandiseOrder M ON O.PONumber = M.PONumber
                                                 WHERE ItemID = (SELECT ItemID 
																 FROM PET..Merchandise 
																 WHERE Description = 'Dog Food-Can-Premium') AND OrderDate BETWEEN '2004-01-01' AND '2004-06-30')
                                                       -
                                                (SELECT SUM(Quantity) 
												 FROM PET..SaleItem SI INNER JOIN PET..Sale SA ON SA.SaleID = SI.SaleID
                                                 WHERE ItemID = (SELECT ItemID 
																 FROM PET..Merchandise 
																 WHERE Description = 'Dog Food-Can-Premium') AND SaleDate BETWEEN '2004-01-01' AND '2004-06-30') AS NetChange
 
FROM PET..Merchandise ME
WHERE ItemID = (SELECT ItemID FROM PET..Merchandise WHERE Description = 'Dog Food-Can-Premium')
 --8.Which merchandise items with a list price of more than $50 hand no sales July?SELECT DISTINCT ME.ItemID, Description, ListPrice
FROM PET..Merchandise ME
INNER JOIN PET..SaleItem SI ON ME.ItemID = SI.ItemID
INNER JOIN PET..Sale SA     ON SI.SaleID = SA.SaleID
WHERE ListPrice > 50 AND
         MONTH(SaleDate) <> 7
 --9. Which merchandise items with more than 100 units on hand have not been ordered in 2004? Use an outer join to answer the question.SELECT DISTINCT M.ITEMID, M.DESCRIPTION, M.QUANTITYONHAND
FROM PET..MERCHANDISE M FULL OUTER JOIN PET..ORDERITEM OI ON M.ITEMID = OI.ITEMID
FULL OUTER JOIN PET..MERCHANDISEORDER MO ON OI.PONUMBER = MO.PONUMBER
WHERE M.QUANTITYONHAND > 100 AND OI.ItemID IS NULL OR YEAR(OrderDate)<>2004--10. Which merchandise items with more than 100 units on hand have not been ordered in 2004? Use a subquery to answer the question.SELECT ITEMID, DESCRIPTION, QUANTITYONHANDFROM PET..MERCHANDISEWHERE ItemID IN (SELECT ME.ITEMID				 FROM	PET..MERCHANDISE ME LEFT OUTER JOIN PET..OrderItem OI ON ME.ItemID=OI.ItemID				 LEFT OUTER JOIN PET..MERCHANDISEORDER MO ON OI.PONUMBER=MO.PONUMBER				 WHERE QuantityOnHand>100 AND OI.ItemID IS NULL OR YEAR(ORDERDATE)<>2004)--11. Save a query to answer Exercise 5: total amount of money spent by each customer. --Create the table shown to categorize customers based on sales.-- Write a query that lists each customer from the first query and displays the proper label.--CREATING TABLECREATE TABLE CATEGORY(CATEGORY CHAR(4) NOT NULL UNIQUE,LOW	INT NOT NULL,HIGH	INT NOT NULL,PRIMARY KEY (CATEGORY));--INSERTING VALUES FOR LATER USEINSERT INTO CATEGORYVALUES('WEAK', 0, 200), ('GOOD' , 200, 800), ('BEST',800, 10000)--TESTSELECT * FROM CATEGORY--create view for query 5CREATE VIEW TEMP_A_PURCH AS
SELECT CUSTOMERID, SUM(SALEPRICE) AS [TOTAL PURCHASES]
FROM PET..SALE S
INNER JOIN PET..SALEANIMAL SA ON S.SALEID = SA.SALEID
GROUP BY CUSTOMERID

CREATE VIEW TEMP_M_PURCH AS
SELECT CUSTOMERID, SUM(QUANTITY*SALEPRICE) AS [TOTAL PURCHASES]
FROM PET..SALE S
INNER JOIN PET..SALEITEM SI ON S.SALEID = SI.SALEID
GROUP BY CUSTOMERIDSELECT TAP.CUSTOMERID, SUM(TAP.[TOTAL PURCHASES] + TMP.[TOTAL PURCHASES]) AS [GRAND
TOTAL] INTO TEMP_CUST_PUR
FROM TEMP_A_PURCH TAP
INNER JOIN TEMP_M_PURCH TMP ON TAP.CUSTOMERID = TMP.CUSTOMERID
GROUP BY TAP.CUSTOMERID
--query
SELECT TCP.CustomerID, LASTNAME, FIRSTNAME, TCP.[GRAND
TOTAL], CATEGORY
FROM TEMP_CUST_PUR [TCP]
INNER JOIN PET..CUSTOMER C ON C.CUSTOMERID = TCP.CUSTOMERID, CATEGORY
WHERE TCP.[GRAND
TOTAL] >=LOW AND TCP.[GRAND
TOTAL] < HIGH--12. List all suppliers (animals and merchandise) who sold us items in June. Identify whether they sold use animals or merchandise.SELECT S.SupplierID, S.Name, 'ANIMAL' AS [ORDERTYPE]FROM	PET..SUPPLIER S INNER JOIN PET..AnimalOrder AO ON S.SupplierID = AO.SupplierIDWHERE	MONTH(AO.OrderDate)=6UNION	ALLSELECT	S.SUPPLIERID, S.NAME, 'MERCHANDISE' AS [ORDERTYPE]FROM	PET..SUPPLIER S INNER JOIN PET..MerchandiseOrder MO ON S.SupplierID= MO.SupplierIDWHERE	MONTH(MO.OrderDate)=6--13. Drop the table Category. Write a query to create the table Category shown in Exercise 11--DROPTABLEDROP TABLE CATEGORY--RECREATE USING QUERYCREATE TABLE CATEGORY(CATEGORY CHAR(4) NOT NULL UNIQUE,LOW	INT NOT NULL,HIGH	INT NOT NULL,PRIMARY KEY (CATEGORY));--TESTSELECT * FROM CATEGORY--14. Write a query to insert the first row of data for the table in Exercise 11.INSERT INTO CATEGORYVALUES('WEAK', 0, 200), ('GOOD' , 200, 800), ('BEST',800, 10000)--15. Write a query to change the High value to 400 in the first row of the table in Exercise 11.UPDATE	CATEGORYSET	HIGH = 400WHERE HIGH=200--17. Create a query to delete the first row of the table in Exercise 11.DELETE FROM	CATEGORYWHERE	CATEGORY='WEAK' AND LOW=0 AND HIGH = 400--18. Create a copy of the Employee table structure. Use a delete query to remove all data from the copy. Write a query to copy from the original employee table into the new one.SELECT	*INTO	EMPLOYEE_COPYFROM	PET..Employee--TEST COPYSELECT	*FROM	EMPLOYEE_COPYSELECT *FROM	PET..Employee--DELETEDELETE FROM EMPLOYEE_COPY--TESTSELECT	*FROM	EMPLOYEE_COPY