


SELECT --Person.Person.Title, Person.Person.FirstName, 
--Person.Person.MiddleName, 
--Person.Person.LastName, 
--Person.Person.Demographics, 
--Sales.Customer.AccountNumber, 
Sales.SalesOrderDetail.OrderQty, 
--Sales.SalesOrderDetail.SpecialOfferID, 
--Sales.SalesOrderDetail.UnitPrice, 
             Sales.SalesOrderDetail.UnitPriceDiscount, 
			 Sales.SalesOrderDetail.LineTotal, 
			 Sales.SalesOrderHeader.OrderDate, 
			 --Sales.SalesOrderHeader.DueDate, 
			 --Sales.SalesOrderHeader.ShipDate, 
			 --Sales.SalesOrderHeader.[Status], Sales.SalesOrderHeader.OnlineOrderFlag, 
             --Sales.SalesOrderHeader.AccountNumber AS purchaseOrderHeaderAcNo, 
			 Sales.SalesOrderHeader.SubTotal, 
			 Sales.SalesOrderHeader.TaxAmt, 
			 --Sales.SalesOrderHeader.Freight, 
			 Sales.SalesOrderHeader.TotalDue, 
			 --Sales.SalesOrderHeader.Comment, 
             Production.ProductSubcategory.[Name] AS subcategoryName, 
			 Sales.SalesTerritory.[Name] AS territoryName, 
			 Sales.SalesTerritory.[Group], 
			 Sales.SalesTerritory.SalesYTD, 
			 Sales.SalesTerritory.SalesLastYear, 
			 Sales.SalesTerritory.CostYTD, 
			 Sales.SalesTerritory.CostLastYear, 
             Production.ProductCategory.[Name] AS productCategoryName, 
			 Production.Product.[Name] AS productName--, 
			 --Production.Product.Color
FROM   Production.ProductCategory INNER JOIN
             Production.ProductSubcategory ON 
			 Production.ProductCategory.ProductCategoryID = Production.ProductSubcategory.ProductCategoryID 
			 AND Production.ProductCategory.ProductCategoryID = Production.ProductSubcategory.ProductCategoryID 
			 AND Production.ProductCategory.ProductCategoryID = Production.ProductSubcategory.ProductCategoryID 
			 AND Production.ProductCategory.ProductCategoryID = Production.ProductSubcategory.ProductCategoryID 
			 AND Production.ProductCategory.ProductCategoryID = Production.ProductSubcategory.ProductCategoryID INNER JOIN
             Production.Product ON Production.ProductSubcategory.ProductSubcategoryID = Production.Product.ProductSubcategoryID CROSS JOIN
             Person.Person INNER JOIN
             Sales.Customer ON Person.Person.BusinessEntityID = Sales.Customer.PersonID INNER JOIN
             Sales.SalesOrderHeader ON Sales.Customer.CustomerID = Sales.SalesOrderHeader.CustomerID 
			 AND Sales.Customer.CustomerID = Sales.SalesOrderHeader.CustomerID INNER JOIN
             Sales.SalesOrderDetail ON Sales.SalesOrderHeader.SalesOrderID = Sales.SalesOrderDetail.SalesOrderID 
			 AND Sales.SalesOrderHeader.SalesOrderID = Sales.SalesOrderDetail.SalesOrderID INNER JOIN
             Sales.SalesTerritory ON Sales.Customer.TerritoryID = Sales.SalesTerritory.TerritoryID 
			 AND Sales.SalesOrderHeader.TerritoryID = Sales.SalesTerritory.TerritoryID 
			 AND Sales.SalesOrderHeader.TerritoryID = Sales.SalesTerritory.TerritoryID
			 where datepart(year,Sales.SalesOrderHeader.OrderDate)=2011

			 --select datepart(year,getdate())


create procedure  select_monthly_sales
AS
select sum(LineTotal) as Total,datepart(month,orderdate) AS Month_Number,
datename(month,OrderDate) as Month_Name
from sales.SalesOrderDetail so
join sales.SalesOrderHeader sh on so.SalesOrderID=sh.SalesOrderID
group by datepart(month,orderdate),datename(month,OrderDate)
order by
Month_Number;


  
create procedure  select_quarterly_sales  
AS  
select sum(LineTotal) as Total,datename(year,OrderDate)+'Q'+CONVERT(  
varchar(20),datepart(QUARTER,orderdate)) AS [Quarter]  
  
from sales.SalesOrderDetail so  
join sales.SalesOrderHeader sh on so.SalesOrderID=sh.SalesOrderID  
group by datepart(quarter,orderdate),datename(year,OrderDate)  
order by  
datename(year,OrderDate),[Quarter];


create procedure  select_weekly_sales
AS
select SUM(LineTotal) as Total,
DATENAME(WEEK,OrderDate) AS [Week],DATENAME(MONTH,OrderDate) AS [Month],
CONVERT(varchar(20),DATENAME(YEAR,OrderDate))  as [Year]

from sales.SalesOrderDetail so
JOIN sales.SalesOrderHeader sh ON so.SalesOrderID=sh.SalesOrderID
group by DATENAME(WEEK,OrderDate),DATENAME(YEAR,OrderDate),DATENAME(MONTH,OrderDate)
order by DATENAME(YEAR,OrderDate),DATENAME(WEEK,OrderDate);

create procedure  select_weekday_sales
AS
select SUM(LineTotal) as Total,
DATENAME(WEEKDAY,OrderDate) AS [WeekDay],DATEPART(WEEKDAY,OrderDate) AS [DayNumber],
datename(year,OrderDate)  AS [Year]


from sales.SalesOrderDetail so
join sales.SalesOrderHeader sh on so.SalesOrderID=sh.SalesOrderID
group by DATENAME(WEEKDAY,OrderDate),DATEPART(WEEKDAY,OrderDate),DATENAME(year,OrderDate)
order by datename(year,OrderDate),DATEPART(WEEKDAY,OrderDate),DATENAME(WEEKDAY,OrderDate)
;



create procedure  select_annual_sales
AS
select SUM(LineTotal) as Total,

DATENAME(YEAR,OrderDate)  AS [Year]


from sales.SalesOrderDetail so
join sales.SalesOrderHeader sh on so.SalesOrderID=sh.SalesOrderID
group by DATENAME(YEAR,OrderDate)
order by DATENAME(YEAR,OrderDate)
--- Annual sales ends


CREATE PROCEDURE select_top_selling_products 
@number_of_products INT,
@year int
AS
SELECT  top (@number_of_products) Production.Product.[Name] AS Product,
 --not including subtotal because it includes taxes and others
SUM(Sales.SalesOrderDetail.LineTotal) AS Total,--DATENAME(WEEKDAY,OrderDate) AS [WeekDay],
DATENAME(MONTH,OrderDate) AS [Month],DATENAME(YEAR,OrderDate) AS [Year],
DATEPART(MONTH,orderdate) AS Month_Number
FROM   Production.Product 
INNER JOIN Sales.SalesOrderDetail 
ON Production.Product.ProductID = Sales.SalesOrderDetail.ProductID 
INNER JOIN Sales.SalesOrderHeader 
ON Sales.SalesOrderDetail.SalesOrderID = Sales.SalesOrderHeader.SalesOrderID
WHERE DATENAME(YEAR,OrderDate)=@year
GROUP BY Production.Product.[Name],--DATENAME(WEEKDAY,OrderDate) ,
DATENAME(MONTH,OrderDate),
DATENAME(YEAR,OrderDate),
DATEPART(MONTH,orderdate)
ORDER BY  DATENAME(YEAR,OrderDate),
DATEPART(MONTH,orderdate),Total DESC
;


CREATE PROCEDURE select_territory_sales 
@year INT
AS

SELECT SUM(Sales.SalesOrderDetail.LineTotal) AS Sales, 
DATENAME(MONTH,Sales.SalesOrderHeader.OrderDate) AS [Month], 
DATENAME(YEAR,Sales.SalesOrderHeader.OrderDate) AS [Year],
DATEPART(MONTH,Sales.SalesOrderHeader.OrderDate) AS [MonthNumber],
Sales.SalesTerritory.Name AS Territory--Sales.SalesTerritory.[Group], 
--Person.CountryRegion.Name AS [RegionName], 
--Sales.SalesTerritory.SalesYTD, 
--Sales.SalesTerritory.SalesLastYear
FROM   Sales.Customer 
INNER JOIN Sales.SalesOrderHeader 
ON Sales.Customer.CustomerID = Sales.SalesOrderHeader.CustomerID 
INNER JOIN Sales.SalesOrderDetail 
ON Sales.SalesOrderHeader.SalesOrderID = Sales.SalesOrderDetail.SalesOrderID 
INNER JOIN Sales.SalesTerritory 
ON Sales.Customer.TerritoryID = Sales.SalesTerritory.TerritoryID 
AND Sales.SalesOrderHeader.TerritoryID = Sales.SalesTerritory.TerritoryID 
INNER JOIN Person.CountryRegion 
ON Sales.SalesTerritory.CountryRegionCode = Person.CountryRegion.CountryRegionCode
WHERE DATENAME(YEAR,Sales.SalesOrderHeader.OrderDate)=@year
GROUP BY Sales.SalesTerritory.Name,
DATENAME(MONTH,Sales.SalesOrderHeader.OrderDate),
DATENAME(YEAR,Sales.SalesOrderHeader.OrderDate),
DATEPART(MONTH,Sales.SalesOrderHeader.OrderDate)

ORDER BY DATENAME(YEAR,Sales.SalesOrderHeader.OrderDate),
DATEPART(MONTH,Sales.SalesOrderHeader.OrderDate)
;





CREATE PROCEDURE select_regional_sales
@year INT
AS
SELECT SUM(Sales.SalesOrderDetail.LineTotal) AS Sales, 
DATENAME(MONTH,Sales.SalesOrderHeader.OrderDate) AS [Month], 
DATENAME(YEAR,Sales.SalesOrderHeader.OrderDate) AS [Year],
DATEPART(MONTH,Sales.SalesOrderHeader.OrderDate) AS [MonthNumber],
--Sales.SalesTerritory.Name AS Territory,--Sales.SalesTerritory.[Group], 
Person.CountryRegion.Name AS [RegionName]
--Sales.SalesTerritory.SalesYTD, 
--Sales.SalesTerritory.SalesLastYear
FROM   Sales.Customer 
INNER JOIN Sales.SalesOrderHeader 
ON Sales.Customer.CustomerID = Sales.SalesOrderHeader.CustomerID 
INNER JOIN Sales.SalesOrderDetail 
ON Sales.SalesOrderHeader.SalesOrderID = Sales.SalesOrderDetail.SalesOrderID 
INNER JOIN Sales.SalesTerritory 
ON Sales.Customer.TerritoryID = Sales.SalesTerritory.TerritoryID 
AND Sales.SalesOrderHeader.TerritoryID = Sales.SalesTerritory.TerritoryID 
INNER JOIN Person.CountryRegion 
ON Sales.SalesTerritory.CountryRegionCode = Person.CountryRegion.CountryRegionCode
WHERE DATENAME(YEAR,Sales.SalesOrderHeader.OrderDate)=@year
GROUP BY --Sales.SalesTerritory.Name,
DATENAME(MONTH,Sales.SalesOrderHeader.OrderDate),
DATENAME(YEAR,Sales.SalesOrderHeader.OrderDate),
DATEPART(MONTH,Sales.SalesOrderHeader.OrderDate),
Person.CountryRegion.Name

ORDER BY DATENAME(YEAR,Sales.SalesOrderHeader.OrderDate),
DATEPART(MONTH,Sales.SalesOrderHeader.OrderDate)
;


CREATE PROCEDURE  select_aggregated_regional_sales 
@year INT
AS

IF @year=''
BEGIN
SELECT SUM(Sales.SalesOrderDetail.LineTotal) AS Sales, 
Person.CountryRegion.Name AS [RegionName]
--Sales.SalesTerritory.SalesYTD, 
--Sales.SalesTerritory.SalesLastYear
FROM   Sales.Customer 
INNER JOIN Sales.SalesOrderHeader 
ON Sales.Customer.CustomerID = Sales.SalesOrderHeader.CustomerID 
INNER JOIN Sales.SalesOrderDetail 
ON Sales.SalesOrderHeader.SalesOrderID = Sales.SalesOrderDetail.SalesOrderID 
INNER JOIN Sales.SalesTerritory 
ON Sales.Customer.TerritoryID = Sales.SalesTerritory.TerritoryID 
AND Sales.SalesOrderHeader.TerritoryID = Sales.SalesTerritory.TerritoryID 
INNER JOIN Person.CountryRegion 
ON Sales.SalesTerritory.CountryRegionCode = Person.CountryRegion.CountryRegionCode
--WHERE DATENAME(YEAR,Sales.SalesOrderHeader.OrderDate)=2011
GROUP BY --Sales.SalesTerritory.Name,
Person.CountryRegion.Name
END
ELSE
BEGIN
SELECT SUM(Sales.SalesOrderDetail.LineTotal) AS Sales, 
Person.CountryRegion.Name AS [RegionName]
--Sales.SalesTerritory.SalesYTD, 
--Sales.SalesTerritory.SalesLastYear
FROM   Sales.Customer 
INNER JOIN Sales.SalesOrderHeader 
ON Sales.Customer.CustomerID = Sales.SalesOrderHeader.CustomerID 
INNER JOIN Sales.SalesOrderDetail 
ON Sales.SalesOrderHeader.SalesOrderID = Sales.SalesOrderDetail.SalesOrderID 
INNER JOIN Sales.SalesTerritory 
ON Sales.Customer.TerritoryID = Sales.SalesTerritory.TerritoryID 
AND Sales.SalesOrderHeader.TerritoryID = Sales.SalesTerritory.TerritoryID 
INNER JOIN Person.CountryRegion 
ON Sales.SalesTerritory.CountryRegionCode = Person.CountryRegion.CountryRegionCode
WHERE DATENAME(YEAR,Sales.SalesOrderHeader.OrderDate)=@year
GROUP BY --Sales.SalesTerritory.Name,
Person.CountryRegion.Name
ORDER BY Sales
END;



--SELECT Production.Product.Name, Production.Product.ListPrice, 
--Sales.SalesOrderDetail.OrderQty, 
--Sales.SalesOrderDetail.UnitPrice, Sales.SalesOrderDetail.LineTotal
--FROM   Production.Product 
--INNER JOIN Sales.SalesOrderDetail 
--ON Production.Product.ProductID = Sales.SalesOrderDetail.ProductID


CREATE PROC select_annual_profits
AS
SELECT 

 SUM((Sales.SalesOrderDetail.UnitPrice-Production.Product.StandardCost)*Sales.SalesOrderDetail.OrderQty) AS Profit,
 DATENAME(YEAR,Sales.SalesOrderHeader.OrderDate) AS [Year]
 
FROM   Production.Product INNER JOIN
             Purchasing.PurchaseOrderDetail  
			 ON Production.Product.ProductID = Purchasing.PurchaseOrderDetail.ProductID 
			 INNER JOIN Sales.SalesOrderDetail 
			 ON Production.Product.ProductID = Sales.SalesOrderDetail.ProductID
			 INNER JOIN SaLes.SalesOrderHeader
			 ON SAles.SalesOrderDetail.SalesOrderDetailID=Sales.SalesOrderDetail.SalesOrderDetailID
GROUP BY DATENAME(YEAR,Sales.SalesOrderHeader.OrderDate) 
ORDER BY 1 DESC
;




CREATE PROC select_monthly_profits
AS
SELECT 

 SUM((Sales.SalesOrderDetail.UnitPrice-Production.Product.StandardCost)*Sales.SalesOrderDetail.OrderQty) AS Profit,
 DATENAME(YEAR,Sales.SalesOrderHeader.OrderDate) AS [Year],
 DATENAME(MONTH,Sales.SalesOrderHeader.OrderDate) AS [Month],
 DATEPART(MONTH,Sales.SalesOrderHeader.OrderDate) AS [MonthNumber]
 
FROM   Production.Product INNER JOIN
             Purchasing.PurchaseOrderDetail  
			 ON Production.Product.ProductID = Purchasing.PurchaseOrderDetail.ProductID 
			 INNER JOIN Sales.SalesOrderDetail 
			 ON Production.Product.ProductID = Sales.SalesOrderDetail.ProductID
			 INNER JOIN SaLes.SalesOrderHeader
			 ON SAles.SalesOrderDetail.SalesOrderDetailID=Sales.SalesOrderDetail.SalesOrderDetailID
GROUP BY DATENAME(YEAR,Sales.SalesOrderHeader.OrderDate) ,
DATEPART(MONTH,Sales.SalesOrderHeader.OrderDate),
DATENAME(MONTH,Sales.SalesOrderHeader.OrderDate)
ORDER BY 2 DESC,4 ASC
;

--quarterly sales and profits
CREATE PROC select_quarterly_Sales_profits
AS
SELECT 

 SUM(Sales.SalesOrderDetail.LineTotal) Sales,
 SUM((Sales.SalesOrderDetail.UnitPrice-Production.Product.StandardCost)*Sales.SalesOrderDetail.OrderQty) AS Profit,
 DATENAME(year,OrderDate)+'Q'+CONVERT(  
varchar(20),DATEPART(QUARTER,orderdate)) AS [Quarter]  
 
FROM   Production.Product INNER JOIN 
Sales.SalesOrderDetail
			 ON Production.Product.ProductID = Sales.SalesOrderDetail.ProductID
			 INNER JOIN SaLes.SalesOrderHeader
			 ON SAles.SalesOrderDetail.SalesOrderDetailID=Sales.SalesOrderDetail.SalesOrderDetailID
GROUP BY DATENAME(YEAR,Sales.SalesOrderHeader.OrderDate) ,
DATEPART(QUARTER,Sales.SalesOrderHeader.OrderDate)
ORDER BY 3 DESC,2 
;


CREATE PROC selecte_aggregated_profit
AS
SELECT  SUM((Sales.SalesOrderDetail.UnitPrice-Production.Product.StandardCost)*Sales.SalesOrderDetail.OrderQty)
AS "Total Profit",
AVG((Sales.SalesOrderDetail.UnitPrice-Production.Product.StandardCost)*Sales.SalesOrderDetail.OrderQty)
AS "Average Profit",
MAX((Sales.SalesOrderDetail.UnitPrice-Production.Product.StandardCost)*Sales.SalesOrderDetail.OrderQty) AS "Max Profit", --Production.Product.Name
MIN((Sales.SalesOrderDetail.UnitPrice-Production.Product.StandardCost)*Sales.SalesOrderDetail.OrderQty) AS "Min Profit"
FROM   Sales.SalesOrderDetail INNER JOIN
             Production.Product ON Sales.SalesOrderDetail.ProductID = Production.Product.ProductID
			 INNER JOIN SALes.SalesOrderHeader
			 ON Sales.SalesOrderDetail.SalesOrderID=Sales.SalesOrderHeader.SalesOrderID;

CREATE PROC select_weekly_profit
AS
SELECT
SUM((Sales.SalesOrderDetail.UnitPrice-Production.Product.StandardCost)*Sales.SalesOrderDetail.OrderQty)
AS "Total Profit",
DATENAME(WEEK,OrderDate) AS [Week],DATENAME(MONTH,OrderDate) AS [Month],
CONVERT(varchar(20),DATENAME(YEAR,OrderDate))  AS [Year]

FROM   Sales.SalesOrderDetail INNER JOIN
             Production.Product ON Sales.SalesOrderDetail.ProductID = Production.Product.ProductID
			 INNER JOIN SALes.SalesOrderHeader
			 ON Sales.SalesOrderDetail.SalesOrderID=Sales.SalesOrderHeader.SalesOrderID
group by DATENAME(WEEK,OrderDate),
DATENAME(YEAR,OrderDate),
DATENAME(MONTH,OrderDate)
ORDER BY 
DATENAME(WEEK,OrderDate)--,DATENAME(YEAR,OrderDate)
;


CREATE PROC  select_weekday_profit
AS
SELECT 
SUM((Sales.SalesOrderDetail.UnitPrice-Production.Product.StandardCost)*Sales.SalesOrderDetail.OrderQty)
AS "Total Profit",
DATENAME(WEEKDAY,OrderDate) AS [WeekDay],DATEPART(WEEKDAY,OrderDate) AS [DayNumber],
datename(year,OrderDate)  AS [Year]
FROM   Sales.SalesOrderDetail INNER JOIN
             Production.Product ON Sales.SalesOrderDetail.ProductID = Production.Product.ProductID
			 INNER JOIN SALes.SalesOrderHeader
			 ON Sales.SalesOrderDetail.SalesOrderID=Sales.SalesOrderHeader.SalesOrderID

group by DATENAME(WEEKDAY,OrderDate),DATEPART(WEEKDAY,OrderDate),DATENAME(year,OrderDate)
order by datename(year,OrderDate),DATEPART(WEEKDAY,OrderDate),DATENAME(WEEKDAY,OrderDate)
;

CREATE PROC select_product_sales_profit 
@stateDate DATETIME,
@endDate DATETIME
AS
SELECT SUM(Sales.SalesOrderDetail.LineTotal) AS LineTotal, Sales.SalesOrderHeader.OrderDate, 

 SUM((Sales.SalesOrderDetail.UnitPrice-Production.Product.StandardCost)*Sales.SalesOrderDetail.OrderQty )
 AS Profit,

Production.Product.Name AS Product
FROM   Production.Product INNER JOIN
             Purchasing.PurchaseOrderDetail  
			 ON Production.Product.ProductID = Purchasing.PurchaseOrderDetail.ProductID INNER JOIN
             Sales.SalesOrderDetail 
			 ON Production.Product.ProductID = Sales.SalesOrderDetail.ProductID
			 INNER JOIN Sales.SalesOrderHeader
			 ON Sales.SalesOrderDetail.SalesOrderID=Sales.SalesOrderHeader.SalesOrderID
WHERE (Sales.SalesOrderHeader.OrderDate BETWEEN @stateDate AND @endDate) 
GROUP BY Sales.SalesOrderHeader.OrderDate,Production.Product.Name
;

--get distinct product names
CREATE  PROC select_products
AS
SELECT DISTINCT(Production.Product.Name) as Product 
FROM production.product ORDER BY Production.Product.Name;

--select getdate()

--linetotal, order date and profit for time series analysis
SELECT  Sales.SalesOrderDetail.LineTotal,  
Sales.SalesOrderHeader.OrderDate,

 (Sales.SalesOrderDetail.UnitPrice-Production.Product.StandardCost)*Sales.SalesOrderDetail.OrderQty AS Profit,
 Production.Product.Name 
FROM   Production.Product INNER JOIN
             Sales.SalesOrderDetail  
			 ON Production.Product.ProductID = Sales.SalesOrderDetail.ProductID 
           
			 INNER JOIN Sales.SalesOrderHeader 
			 ON Sales.SalesOrderDetail.SalesOrderID=Sales.SalesOrderHeader.SalesOrderID
			 

--select distinct(production.product.name) from production.product



SELECT Sales.SalesOrderDetail.LineTotal, Sales.SalesOrderDetail.UnitPrice, 
Sales.SalesOrderDetail.UnitPriceDiscount, Sales.SalesOrderDetail.OrderQty as "sales order qty",

 (Sales.SalesOrderDetail.UnitPrice-Production.Product.StandardCost)*Sales.SalesOrderDetail.OrderQty AS Profit,

Production.Product.Name AS Product, Production.Product.ListPrice, Production.Product.StandardCost,
Purchasing.PurchaseOrderDetail.OrderQty, Purchasing.PurchaseOrderDetail.UnitPrice AS ["PO Unit Price"], 
             Purchasing.PurchaseOrderDetail.LineTotal AS ["PO LineTotal"]
FROM   Production.Product INNER JOIN
             Purchasing.PurchaseOrderDetail  
			 ON Production.Product.ProductID = Purchasing.PurchaseOrderDetail.ProductID INNER JOIN
             Sales.SalesOrderDetail 
			 ON Production.Product.ProductID = Sales.SalesOrderDetail.ProductID