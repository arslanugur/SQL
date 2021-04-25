# 1. Summarising Data
# 1.1 Data analysis with aggregations
# 1.2 Creating aggregations
This chapter uses data gathered by the National UFO Reporting Center. 
The data is contained in the Incidents table and in this lesson, you will be aggregating values in the DurationSeconds column.

Instruction: Write a T-SQL query which will return the average, minimum, and maximum values of the DurationSeconds column.

-- Calculate the average, minimum and maximum
SELECT 
  AVG(DurationSeconds) AS Average,   
  MIN(DurationSeconds) AS Minimum,     
  MAX(DurationSeconds) AS Maximum
FROM Incidents

# 1.3 Creating grouped aggregations
You can calculate statistics for each group using GROUP BY. 
For example, you can calculate the maximum value for each state using the following query:

SELECT State, MAX(DurationSeconds)
FROM Incidents
GROUP BY State

To filter even further, for example, to find the values for states where the maximum value is greater than 10, you can use the HAVING clause.

Instruction 1
Write a T-SQL query to calculate the average, minimum, and maximum values of the DurationSeconds column grouped by Shape. 
You need to select an additional column. What is it?

-- Calculate the aggregations by Shape
SELECT 
  Shape,       
  AVG(DurationSeconds) AS Average,        
  MIN(DurationSeconds) AS Minimum,        
  MAX(DurationSeconds) AS Maximum
FROM Incidents
GROUP BY Shape

Instruction 2: Update the query to return only the records where the minimum of DurationSeconds column is greater than 1.

-- Calculate the aggregations by Shape
SELECT 
  Shape,       
  AVG(DurationSeconds) AS Average,        
  MIN(DurationSeconds) AS Minimum,        
  MAX(DurationSeconds) AS Maximum
FROM Incidents
GROUP BY Shape
-- Return records where minimum of DurationSeconds is greater than 1
HAVING MIN(DurationSeconds) > 1


# 1.4 Dealing with missing data
# 1.5 Removing missing values
There are a number of different techniques you can use to fix missing data in T-SQL and in this exercise, you will focus on returning rows with non-missing values. 
For example, to return all rows with non-missing SHAPE values, you can use:

SELECT *  
FROM Incidents
WHERE Shape IS NOT NULL

Instruction: Write a T-SQL query which returns only the IncidentDateTime and IncidentState columns where IncidentState is not missing.

-- Return the specified columns
SELECT IncidentDateTime, IncidentState
FROM Incidents
-- Exclude all the missing values from IncidentState  
WHERE IncidentState IS NOT NULL

# 1.6 Imputing missing values (I)
In the previous exercise, you looked at the non-missing values in the IncidentState column. 
But what if you want to replace the missing values with another value instead of omitting them? You can do this using the ISNULL() function. 
Here we replace all the missing values in the Shape column using the word 'Saucer':

SELECT  Shape, ISNULL(Shape, 'Saucer') AS Shape2
FROM Incidents

You can also use ISNULL() to replace values from a different column instead of a specified word.

Instruction
Write a T-SQL query which only returns rows where IncidentState is missing.
Replace all the missing values in the IncidentState column with the values in the City column and name this new column Location.

-- Check the IncidentState column for missing values and replace them with the City column
SELECT 
  IncidentState, 
  ISNULL(IncidentState, City) AS Location
FROM Incidents
-- Filter to only return missing values from IncidentState
WHERE IncidentState IS NULL


# 1.7 Imputing missing values (II)
What if you want to replace missing values in one column with another and want to check the replacement column to make sure it doesn’t have any missing values? 
To do that you need to use the COALESCE statement.

Instruction
Replace missing values in Country with the first non-missing value from IncidentState or City, in that order. Name the new column Location.

-- Replace missing values 
SELECT 
  Country, 
  COALESCE(Country, IncidentState, City) AS Location
FROM Incidents
WHERE Country IS NULL


# 1.8 Binning data with CASE
# 1.9 Using CASE statements
In this exercise, you will use a CASE statement to create a new column which specifies whether the Country is USA or International.

Instruction: Create a new column, SourceCountry, defined from these cases:
When Country is 'us' then it takes the value 'USA'.
Otherwise it takes the value 'International'.

SELECT 
  Country,        
  CASE WHEN Country = 'us' THEN 'USA'       
       ELSE 'International'       
       END AS SourceCountry
FROM Incidents

# 1.10 Creating several groups with CASE
In this exercise, you will write a CASE statement to group the values in the DurationSeconds into 5 groups based on the following ranges:

DurationSeconds	        SecondGroup
        <= 120          1
> 120 and <= 600       	2
> 600 and <= 1200	      3
> 1201 and <= 5000	    4
For all other values	  5

Instruction
Create a new column, SecondGroup, that uses the values in the DurationSeconds column based on the ranges mentioned above.

-- Complete the syntax for cutting the duration into different cases
SELECT 
  DurationSeconds, 
-- Start with the 2 TSQL keywords, and after the condition a TSQL word and a value      
  CASE WHEN (DurationSeconds <= 120) THEN 1
-- The pattern repeats with the same keyword and after the condition the same word and next value                 
  WHEN (DurationSeconds > 120 AND DurationSeconds <= 600) THEN 2
-- Use the same syntax here                    
  WHEN (DurationSeconds > 601 AND DurationSeconds <= 1200) THEN 3
-- Use the same syntax here                      
  WHEN (DurationSeconds > 1201 AND DurationSeconds <= 5000) THEN 4
-- Specify a value             
  ELSE 5        
  END AS SecondGroup   
FROM Incidents


# 2. Math Functions
# 2.1 Counting and totals
# 2.2 Calculating the total
In this chapter, you will use the shipments data. The Shipments table has several columns such as:

MixDesc: the concrete type
Quantity: the amount of concrete shipped
In this exercise, your objective is to calculate the total quantity for each type of concrete used.
Instruction: Write a T-SQL query which will return the sum of the Quantity column as Total for each type of MixDesc.

-- Write a query that returns an aggregation 
SELECT 
  MixDesc, 
  SUM(Quantity) AS Total
FROM Shipments
-- Group by the relevant column
GROUP BY MixDesc


# 2.3 Counting the number of rows
In this exercise, you will calculate the number of orders for each concrete type. 
Since each row represents one order, all you need to is count the number of rows for each type of MixDesc.

Instruction: Create a query that returns the number of rows for each type of MixDesc.

-- Count the number of rows by MixDesc
SELECT 
  MixDesc, 
  COUNT(*)
FROM Shipments
GROUP BY MixDesc

# 2.4 Dates
# 2.5 Which date function should you use?
Suppose you want to calculate the number of years between two different dates, DateOne and DateTwo. 
Which SQL statement would you use to perform that calculation?
■ SELECT DATEDIFF(YYYY, DateOne, DateTwo)

# 2.6 Counting the number of days between dates
In this exercise, you will calculate the difference between the order date and ship date.

Instruction: Write a query that returns the number of days between OrderDate and ShipDate.

-- Return the difference in OrderDate and ShipDate
SELECT 
  OrderDate, 
  ShipDate,        
  DATEDIFF(DD, OrderDate, ShipDate) AS Duration
FROM Shipments


# 2.7 Adding days to a date
In this exercise, you will calculate the approximate delivery date of an order based on ShipDate.

Instruction: Write a query that returns the approximate delivery date as five days after the ShipDate.

-- Return the DeliveryDate as 5 days after the ShipDate
SELECT 
  OrderDate,        
  DATEADD(DD, 5, ShipDate) AS DeliveryDate
FROM Shipments

# 2.8 Rounding and truncating
# 2.9 Rounding numbers
Sometimes, you only care about the whole dollar amount and want to ignore the decimal values of the cost. 
In this exercise, you will round the cost to the nearest dollar.

Instruction: Write a SQL query to round the values in the Cost column to the nearest whole number.

-- Round Cost to the nearest dollar
SELECT 
  Cost,        
  ROUND(Cost, 0) AS RoundedCost
FROM Shipments


# 2.10 Truncating numbers
Since rounding can sometimes be misleading, i.e., $16.8 becomes $17 while $16.4 remains $16, you may want to truncate the values after the decimal instead of rounding them. 
When you truncate the numbers, both $16.8 and $16.4 remain $16. In this exercise, you will do just that, truncate the Cost column to a whole number.

Instruction: Write a SQL query to truncate the values in the Cost column to the nearest whole number.

-- Truncate cost to whole number
SELECT 
  Cost,        
  ROUND(Cost,0,1) AS TruncateCost
FROM Shipments

# 2.11 More math functions
# 2.12 Calculating the absolute value
The Shipments table contains some bad data. There was a problem with the scales, and the weights show up as negative numbers. 
In this exercise, you will write a query to convert all negative weights to positive weights.

Instruction: Write a query that converts all the negative values in the DeliveryWeight column to positive values.

-- Return the absolute value of DeliveryWeight
SELECT 
  DeliveryWeight,       
  ABS(DeliveryWeight) AS AbsoluteValue
FROM Shipments

# 2.13 Calculating squares and square roots
It’s time for you to practice calculating squares and square roots of columns.

Instruction: Write a query that calculates the square and square root of the WeightValue column.

-- Return the square and square root of WeightValue
SELECT 
  WeightValue,        
  SQUARE(WeightValue) AS WeightSquare,        
  SQRT(WeightValue) AS WeightSqrt
FROM Shipments


# 3. Processing Data in SQL Server
# 3.1 WHILE loops
# 3.2 Creating and using variables
In T-SQL, to create a variable you use the DECLARE statement. The variables must have an at sign (@) as their first character. 
Like most things in T-SQL, variables are not case sensitive. 
To assign a value to a variable, you can either use the keyword SET or a SELECT statement, 
then the variable name followed by an equal sign and a value.

Instruction 1
Create an integer variable named counter.
Assign the value 20 to this variable.
-- Declare the variable (a SQL Command, the var name, the datatype)
DECLARE @counter INT
-- Set the counter to 20
SET @counter = 20
-- Select the counter
SELECT @counter

Instruction 2: Increment the variable counter by 1 and assign it back to counter.

-- Declare the variable (a SQL Command, the var name, the datatype)
DECLARE @counter INT 
-- Set the counter to 20
SET @counter = 20
-- Select and increment the counter by one 
SELECT @counter = @counter + 1
-- Print the variable
SELECT @counter


# 3.3 Creating a WHILE loop
In this exercise, you will use the variable you created in the previous exercise you write a WHILE loop. Recall that structure:

WHILE some_condition 
BEGIN 
    -- Perform some operation here
END

Instruction: Write a WHILE loop that increments counter by 1 until counter is less than 30.

DECLARE @counter INT 
SET @counter = 20
-- Create a loop
WHILE @counter < 30
-- Loop code starting point
BEGIN    
  SELECT @counter = @counter + 1
-- Loop finish
  END
-- Check the value of the variable
SELECT @counter


# 3.4 Derived tables
# 3.5 Queries with derived tables (I)
The focus of this lesson is derived tables. You can use derived tables when you want to break down a complex query into smaller steps. 
A derived table is a query which is used in the place of a table. 
Derived tables are a great solution if you want to create intermediate calculations that need to be used in a larger query.

In this exercise, you will calculate the maximum value of the blood glucose level for each record by age.

Instruction
Return MaxGlucose from the derived table.
Join the derived table to the main query on Age.
SELECT 
  a.RecordId, 
  a.Age, 
  a.BloodGlucoseRandom, 
-- Select maximum glucose value (use colname from derived table)  
  b.MaxGlucose
FROM Kidney a
-- Join to derived table
INNER JOIN (
  SELECT
    Age, 
    MAX(BloodGlucoseRandom) AS MaxGlucose 
  FROM Kidney 
  GROUP BY Age
) b
-- Join on Age
ON a.Age = b.Age

# 3.6 Queries with derived tables (II)
In this exercise, you will create a derived table to return all patient records with the highest BloodPressure at their Age level.

Instruction
Create a derived table
- returning Age and MaxBloodPressure; the latter is the maximum of BloodPressure. 
- is taken from the kidney table. 
- is grouped by Age.

Join the derived table to the main query on blood pressure equal to max blood pressure, age.
SELECT *
FROM Kidney a
-- Create derived table: select age, max blood pressure from kidney grouped by age
JOIN (
  SELECT 
    Age, 
    MAX(BloodPressure) AS MaxBloodPressure 
  FROM kidney 
  GROUP BY Age 
) b
-- JOIN on BloodPressure equal to MaxBloodPressure
ON 
  a.BloodPressure = b.MaxBloodPressure AND 
-- Join on Age
  a.Age = b.Age
  
  
# 3.7 Common Table Expressions
# 3.8 CTE syntax
Select all the T-SQL keywords used to create a Common table expression.
■ AS
■ WITH

# 3.9 Creating CTE (I)
A Common table expression or CTE is used to create a table that can later be used with a query. 
To create a CTE, you will always use the WITH keyword followed by the CTE name and the name of the columns the CTE contains. 
The CTE will also include the definition of the table enclosed within the AS().

In this exercise, you will use a CTE to return all the ages with the maximum BloodGlucoseRandom in the table.

Instruction
Create a CTE BloodGlucoseRandom that returns one column (MaxGlucose) which contains the maximum BloodGlucoseRandom in the table.
Join the CTE to the main table (Kidney) on BloodGlucoseRandom and MaxGlucose.
-- Specify the keyowrds to create the CTE
WITH BloodGlucoseRandom (MaxGlucose) AS (
  SELECT MAX(BloodGlucoseRandom) AS MaxGlucose 
  FROM Kidney
)

SELECT a.Age, b.MaxGlucose
FROM 
  Kidney a
-- Join the CTE on blood glucose equal to max blood glucose
JOIN 
  BloodGlucoseRandom b
ON 
  a.BloodGlucoseRandom = b.MaxGlucose


# 3.10 Creating CTE (II)
In this exercise, you will use a CTE to return all the information regarding the patient(s) with the maximum BloodPressure.

Instruction
Create a CTE BloodPressure that returns one column (MaxBloodPressure) which contains the maximum BloodPressure in the table.
Join this CTE (using an alias b) to the main table (Kidney) to return information about patients with the maximum BloodPressure.

-- Create the CTE
WITH BloodPressure(MaxBloodPressure)AS (
  SELECT MAX(BloodPressure) 
  FROM Kidney
)
    
SELECT * 
FROM 
  Kidney a
-- Join the CTE  
JOIN 
  BloodPressure b
ON 
  a.BloodPressure = b.MaxBloodPressure
 

# 4. Window Functions
# 4.1 Window functions in T-SQL
# 4.2 Window functions with aggregations (I)
To familiarize yourself with the window functions, you will work with the Orders table in this chapter. 
Recall that using OVER(), you can create a window for the entire table. 
To create partitions using a specific column, you need to use OVER() along with PARTITION BY.

Instruction: Write a T-SQL query that returns the sum of OrderPrice by creating partitions for each TerritoryName.

SELECT 
  OrderID, 
  TerritoryName,        
-- Total price for each partition       
  SUM(OrderPrice)        
-- Create the window and partitions       
  OVER(PARTITION BY TerritoryName) AS TotalPrice
FROM Orders

# 4.3 Window functions with aggregations (II)
In the last exercise, you calculated the sum of all orders for each territory. 
In this exercise, you will calculate the number of orders in each territory.

Instruction
Count the number of rows in each partition.
Partition the table by TerritoryName.
SELECT 
  OrderID, 
  TerritoryName,        
-- Number of rows per partition       
  COUNT(*)        
-- Create the window and partitions       
  OVER (PARTITION BY TerritoryName) AS TotalOrders
FROM Orders

# 4.4 Common window functions
# 4.5 Do you know window functions?
Which of the following statements is incorrect regarding window queries?
■ The standard aggregations like SUM(), AVG(), and COUNT() require ORDER BY in the OVER() clause.

# 4.6 First value in a window
Suppose you want to figure out the first OrderDate in each territory or the last one. 
How would you do that? You can use the window functions FIRST_VALUE() and LAST_VALUE(), respectively! Here are the steps:

First, create partitions for each territory
Then, order by OrderDate
Finally, use the FIRST_VALUE() and/or LAST_VALUE() functions as per your requirement
Instruction: Write a T-SQL query that returns the first OrderDate by creating partitions for each TerritoryName.

SELECT 
  TerritoryName, 
  OrderDate,        
-- Select the first value in each partition      
  FIRST_VALUE(OrderDate)        
-- Create the partitions and arrange the rows       
  OVER(PARTITION BY TerritoryName 
       ORDER BY OrderDate) AS FirstOrder
FROM Orders

# 4.7 Previous and next values
What if you want to shift the values in a column by one row up or down? 
You can use the exact same steps as in the previous exercise but with two new functions, LEAD(), for the next value, and LAG(), for the previous value. 
So you follow these steps:
First, create partitions
Then, order by a certain column
Finally, use the LEAD() and/or LAG() functions as per your requirement

Instruction: Write a T-SQL query that for each territory:
Shifts the values in OrderDate one row down. Call this column PreviousOrder.
Shifts the values in OrderDate one row up. Call this column NextOrder.You will need to PARTITION BY the territory

SELECT 
  TerritoryName, 
  OrderDate,        
  -- Specify the previous OrderDate in the window       
  LAG(OrderDate)        
  -- Over the window, partition by territory & order by order date       
  OVER(PARTITION BY TerritoryName 
       ORDER BY OrderDate) AS PreviousOrder,       
-- Specify the next OrderDate in the window       
  LEAD(OrderDate)        
  -- Create the partitions and arrange the rows       
  OVER(PARTITION BY TerritoryName
       ORDER BY OrderDate) AS NextOrder
FROM Orders


# 4.8 Increasing window complexity
# 4.9 Creating running totals
You usually don’t have to use ORDER BY when using aggregations, but if you want to create running totals, you should arrange your rows! 
In this exercise, you will create a running total of OrderPrice.

Instruction: Create the window, partition by TerritoryName and order by OrderDate to calculate a running total of OrderPrice.

SELECT 
  TerritoryName, 
  OrderDate,        
-- Create a running total       
  SUM(OrderPrice)       
-- Create the partitions and arrange the rows       
  OVER(PARTITION BY TerritoryName 
       ORDER BY OrderDate) AS TerritoryTotal      
FROM Orders

# 4.10 Assigning row numbers
Records in T-SQL are inherently unordered. Although in certain situations, you may want to assign row numbers for reference. 
In this exercise, you will do just that.

Instruction: Write a T-SQL query that assigns row numbers to all records partitioned by TerritoryName and ordered by OrderDate.

SELECT 
  TerritoryName, 
  OrderDate,        
-- Assign a row number       
  ROW_NUMBER()        
-- Create the partitions and arrange the rows       
  OVER(PARTITION BY TerritoryName 
       ORDER BY OrderDate) AS OrderCount
FROM Orders

# 4.11 Using window for statistical functions
# 4.12 Calculating standard deviation
Calculating the standard deviation is quite common when dealing with numeric columns. 
In this exercise, you will calculate the running standard deviation, similar to the running total you calculated in the previous lesson.

Instruction: Create the window, partition by TerritoryName and order by OrderDate to calculate a running standard deviation of OrderPrice.

SELECT 
  OrderDate, 
  TerritoryName,   
-- Calculate the standard deviation          
  STDEV(OrderPrice) 
  OVER(PARTITION BY TerritoryName 
       ORDER BY OrderDate) AS StdDevPrice      
FROM Orders

# 4.13 Calculating mode (I)
Unfortunately, there is no function to calculate the mode, the most recurring value in a column. To calculate the mode:

First, create a CTE containing an ordered count of values using ROW_NUMBER()
Write a query using the CTE to pick the value with the highest row number
In this exercise, you will write the CTE needed to calculate the mode of OrderPrice.

Instruction
Create a CTE ModePrice that returns two columns (OrderPrice and UnitPriceFrequency).
Write a query that returns all rows in this CTE.

-- Create a CTE Called ModePrice which contains two columns
WITH ModePrice (OrderPrice, UnitPriceFrequency) AS(    
  SELECT 
    OrderPrice,     
    ROW_NUMBER() 
    OVER(PARTITION BY OrderPrice 
         ORDER BY OrderPrice) AS UnitPriceFrequency    
  FROM Orders )
                      
-- Select everything from the CTE
SELECT *
FROM ModePrice

# 4.14 Calculating mode (II)
In the last exercise, you created a CTE which assigned row numbers to each unique value in OrderPrice. 
All you need to do now is to find the OrderPrice with the highest row number.

Instruction: Use the CTE ModePrice to return the value of OrderPrice with the highest row number.

-- CTE from the previous exercise
WITH ModePrice (OrderPrice, UnitPriceFrequency)AS(    
  SELECT 
    OrderPrice,    
    ROW_NUMBER() 
    OVER (PARTITION BY OrderPrice 
          ORDER BY OrderPrice) AS UnitPriceFrequency       
  FROM Orders)
  
-- Select the order price from the CTE
SELECT 
  OrderPrice AS ModeOrderPrice
FROM ModePrice
-- Select the maximum UnitPriceFrequency from the CTE
WHERE 
  UnitPriceFrequency IN (
  SELECT 
    MAX(UnitPriceFrequency) 
  From 
    ModePrice
  )
  
