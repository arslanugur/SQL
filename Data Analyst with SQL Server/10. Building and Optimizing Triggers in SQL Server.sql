1. Introduction to Triggers
An introduction to the basic concepts of SQL Server triggers. Create your first trigger using T-SQL code. 
Learn how triggers are used and what alternatives exist.

1.1. Introduction - Video
1.2. Types of trigger
Data Manipulation Language (DML) triggers are executed when a user or process tries to modify data in a given table. 
A trigger can be fired in response to these statements.

What are the three DML statements that can be used to fire triggers?
---> DELETE / INSERT / UPDATE

1.3. Creating your first trigger
You have been hired by the company Fresh Fruit Delivery to help secure their database and ensure data integrity. 
The company sells fresh fruit to other online shops, and they use several tables to keep track of stock and placed orders.

One of their tables (Discounts) specifies the discount amount that shops receive when placing large orders. 
A deletion of several hundred rows happened at some point in the past when one of their employees removed some orders by mistake. 
They need a new trigger on the Discounts table to prevent DELETE statements related to the table, and this is where you can help.

Instructions
Create a new trigger on the Discounts table.
Use the trigger to prevent DELETE statements.

-- Create a new trigger that fires when deleting data
CREATE TRIGGER PreventDiscountsDelete
ON Discounts
-- The trigger should fire instead of DELETE
INSTEAD OF DELETE
AS
	PRINT 'You are not allowed to delete data from the Discounts table.';

1.4. Practicing creating triggers
The Fresh Fruit Delivery company needs help creating a new trigger called OrdersUpdatedRows on the Orders table.

This trigger will be responsible for filling in a historical table (OrdersUpdate) where information about the updated rows is kept.

A historical table is often used in practice to store information that has been altered in the original table. 
In this example, changes to orders will be saved into OrdersUpdate to be used by the company for auditing purposes.

Instructions:
Create the new trigger for the Orders table.
Set the trigger to be fired only after UPDATE statements.

-- Set up a new trigger
CREATE TRIGGER OrdersUpdatedRows
ON Orders
-- The trigger should fire after UPDATE statements
AFTER UPDATE
-- Add the AS keyword before the trigger body
AS
	-- Insert details about the changes to a dedicated table
	INSERT INTO OrdersUpdate(OrderID, OrderDate, ModifyDate)
	SELECT OrderID, OrderDate, GETDATE()
	FROM inserted;
  
1.5. How DML triggers are used
1.6. When to use triggers
Triggers are a good way to execute additional actions when changes occur in your database.
Triggers can also be used to prevent changes and execute different actions instead.

Which of the following could be valid use cases for triggers?
Possible Answers
---> To send an email to the Sales team when a new order is added to the Orders table
---> To copy the modified rows to a history table when an update occurs on the Products table
---> To deny the creation of a new database in SQL Server

1.7. Creating a trigger to keep track of data changes
The Fresh Fruit Delivery company needs to keep track of any new items added to the Products table. You can do this by using a trigger.

The new trigger will store the name, price, and first introduced date for new items into a ProductsHistory table.

 Create the ProductsNewItems trigger on the Products table.
 Set the trigger to fire when data is inserted into the table.

-- Create a new trigger
CREATE TRIGGER ProductsNewItems
ON Products
AFTER INSERT
AS
	-- Add details to the history table
	INSERT INTO ProductsHistory(Product, Price, Currency, FirstAdded)
	SELECT Product, Price, Currency, GETDATE()
	FROM inserted;
  
1.8. Trigger alternatives - Video
1.9. Triggers vs. stored procedures
One important task when you take ownership of an existing database is to familiarize yourself with the objects that comprise the database.

This task includes getting to know existing procedures, functions, and triggers.

You find the following objects in the Fresh Fruit Delivery database:

The company uses a regular stored procedure, MonthlyOrders, for reporting purposes. The stored procedure sums up order amounts for each product every month.

The trigger CustomerDiscountHistory is used to keep a history of the changes that occur in the Discounts table. The trigger is fired when updates are made to the Discounts table, and it stores the old and new values from the Discount column into the table DiscountsHistory.

 Run an update on the Discounts table (this will fire the CustomerDiscountHistory trigger).
 Get all the rows from DiscountsHistory to verify the outcome.
-- Run an update for some of the discounts
UPDATE Discounts
SET Discount = Discount + 1
WHERE Discount <= 5;

-- Verify the trigger ran successfully
SELECT * FROM DiscountsHistory;
Question Execute the MonthlyOrders regular stored procedure, using EXECUTE MonthlyOrders.

Then, try to execute the CustomerDiscountHistory trigger using
UPDATE Discounts SET Discount = Discount + 1 WHERE Discount <= 5

What conclusions can be drawn from the execution results and the step performed earlier?
---  Both triggers and regular stored procedures can be executed explicitly when needed.
---> Triggers can only be fired by the corresponding event, while regular stored procedures can be executed explicitly when needed.
---  Triggers can be executed explicitly when needed, while regular stored procedures can only be fired by a corresponding event.
---  Triggers can be fired by the corresponding event, but can also be executed explicitly when needed.
 
1.10. Triggers vs. computed columns
While continuing your analysis of the database, you find two other interesting objects:
The table SalesWithPrice has a column that calculates the TotalAmount as Quantity * Price. 
This is done using a computed column which uses columns from the same table for the calculation.

The trigger SalesCalculateTotalAmount was created on the SalesWithoutPrice table. 
The Price column is not part of the SalesWithoutPrice table, so a computed column cannot be used for the TotalAmount. 
The trigger overcomes this limitation by using the Price column from the Products table.

Insert new data into SalesWithPrice and then run a SELECT from the same table to verify the outcome.

-- Add the following rows to the table
INSERT INTO SalesWithPrice (Customer, Product, Price, Currency, Quantity)
VALUES ('Fruit Mag', 'Pomelo', 1.12, 'USD', 200),
	   ('VitaFruit', 'Avocado', 2.67, 'USD', 400),
	   ('Tasty Fruits', 'Blackcurrant', 2.32, 'USD', 1100),
	   ('Health Mag', 'Kiwi', 1.42, 'USD', 100),
	   ('eShop', 'Plum', 1.1, 'USD', 500);

-- Verify the results after adding the new rows
SELECT * FROM SalesWithPrice;

Insert new data into SalesWithoutPrice and then run a SELECT from the same table to verify the outcome.

-- Add the following rows to the table
INSERT INTO SalesWithoutPrice (Customer, Product, Currency, Quantity)
VALUES ('Fruit Mag', 'Pomelo', 'USD', 200),
	   ('VitaFruit', 'Avocado', 'USD', 400),
	   ('Tasty Fruits', 'Blackcurrant', 'USD', 1100),
	   ('Health Mag', 'Kiwi', 'USD', 100),
	   ('eShop', 'Plum', 'USD', 500);

-- Verify the results after the INSERT
SELECT * FROM SalesWithoutPrice;
Question The previous step used both a computed column and a trigger to calculate the TotalAmount value automatically. From a user perspective, there was no difference, but from a technical perspective, there is one.

What is the major limitation of computed columns that can be easily overcome with the use of triggers?
---> A computed column cannot use columns from other tables for the calculation.


2. Classification of Triggers
Learn about the different types of SQL Server triggers: AFTER triggers (DML), INSTEAD OF triggers (DML), DDL triggers, and logon triggers.

2.1. AFTER triggers (DML) - Video
2.2. Tracking retired products
As shown in the example from the video, Fresh Fruit Delivery needs to keep track of any retired products in a dedicated history table (RetiredProducts).

You are asked to create a new trigger that fires when rows are removed from the Products table.

The information about the removed rows will be saved into the RetiredProducts table.

 Create the TrackRetiredProducts trigger on the Products table.
 Set the trigger to fire after rows are deleted from the table.
-- Create the trigger
CREATE TRIGGER TrackRetiredProducts
ON Products
AFTER DELETE
AS
	INSERT INTO RetiredProducts (Product, Measure)
	SELECT Product, Measure
	FROM deleted;
  
2.3. The TrackRetiredProducts trigger in action
Once you've created a trigger, it's always a good idea to see if it performs as expected.

The company's request for the trigger created earlier was based on a real need: 
they want to retire several products from their offering. This means you can check the trigger in action.

 Remove retired items from the Products table and check the output from the RetiredProducts table.
 
-- Remove the products that will be retired
DELETE FROM Products
WHERE Product IN ('Cloudberry', 'Guava', 'Nance', 'Yuzu');

-- Verify the output of the history table
SELECT * FROM RetiredProducts;

2.4. Practicing with AFTER triggers
Fresh Fruit Delivery company is happy with your services, and they've decided to keep working with you.

You have been given the task to create new triggers on some tables, with the following requirements:
Keep track of canceled orders (rows deleted from the Orders table). Their details will be kept in the table CanceledOrders upon removal.
Keep track of discount changes in the table Discounts. Both the old and the new values will be copied to the DiscountsHistory table.
Send an email to the Sales team via the SendEmailtoSales stored procedure when a new order is placed.

 Create a new trigger on the Orders table to keep track of any canceled orders.

-- Create a new trigger for canceled orders
CREATE TRIGGER KeepCanceledOrders
ON Orders
AFTER DELETE
AS 
	INSERT INTO CanceledOrders
	SELECT * FROM deleted;
  
 Create a new trigger on the Discounts table to keep track of discount value changes.

-- Create a new trigger to keep track of discounts
CREATE TRIGGER CustomerDiscountHistory
ON Discounts
AFTER UPDATE
AS
	-- Store old and new values into the `DiscountsHistory` table
	INSERT INTO DiscountsHistory (Customer, OldDiscount, NewDiscount, ChangeDate)
	SELECT i.Customer, d.Discount, i.Discount, GETDATE()
	FROM inserted AS i
	INNER JOIN deleted AS d ON i.Customer = d.Customer;
  

 Create the trigger NewOrderAlert to notify the Sales team when new orders are placed.
 
-- Notify the Sales team of new orders
CREATE TRIGGER NewOrderAlert
ON Orders
AFTER INSERT
AS
	EXECUTE SendEmailtoSales;
  
  
2.5. INSTEAD OF triggers (DML) - Video
2.6. Preventing changes to orders
Fresh Fruit Delivery needs to prevent changes from being made to the Orders table.

Any attempt to do so should not be permitted and an error should be shown instead.

 Create a new trigger on the Orders table.
 Set the trigger to prevent updates and return an error message instead.

-- Create the trigger
CREATE TRIGGER PreventOrdersUpdate
ON Orders
INSTEAD OF UPDATE
AS
	RAISERROR ('Updates on "Orders" table are not permitted.
                Place a new order to add new products.', 16, 1);
                
 
2.7. PreventOrdersUpdate in action
Let's see what the newly created trigger does when you try to update some rows in the Orders table.
Run the following script to change the order quantity to 700 for order number 425:

UPDATE Orders SET Quantity = 700 WHERE OrderID = 425;

What happens when you run the code?
---  Nothing. There is no output in the query results pane.
---> The query results pane shows an error thrown by the new trigger.
---  The update is run successfully after the trigger runs.

2.8. Creating the PreventNewDiscounts trigger
The company doesn't want regular users to add discounts. Only the Sales Manager should be able to do that.

To prevent such changes, you need to create a new trigger called PreventNewDiscounts.
The trigger should be attached to the Discounts table and prevent new rows from being added to the table.

 Create the trigger PreventNewDiscounts on the Discounts table.
 Set the trigger to prevent any rows being added to the Discounts table.
-- Create a new trigger
CREATE TRIGGER PreventNewDiscounts
ON Discounts
INSTEAD OF INSERT
AS
	RAISERROR ('You are not allowed to add discounts for existing customers.
                Contact the Sales Manager for more details.', 16, 1);
                
                
2.9. DDL triggers - Video
2.10. Tracking table changes
You need to create a new trigger at the database level that logs modifications to the table TablesChangeLog.

The trigger should fire when tables are created, modified, or deleted.

 Create the new trigger following the company's requirements.
-- Create the trigger to log table info
CREATE TRIGGER TrackTableChanges
ON DATABASE
FOR CREATE_TABLE,
	ALTER_TABLE,
	DROP_TABLE
AS
	INSERT INTO TablesChangeLog (EventData, ChangedBy)
    VALUES (EVENTDATA(), USER);
    
2.11. Using FOR in a trigger
What is the purpose of the FOR clause when used in a trigger definition?
---> FOR is a synonym of AFTER and performs the trigger's set of actions after the triggering event finish

2.12. Preventing table deletion
Fresh Fruit Delivery wants to prevent its regular employees from deleting tables from the database.

 Create a new trigger, PreventTableDeletion, to prevent table deletion.
 The trigger should roll back the firing statement, so the deletion does not happen.

-- Add a trigger to disable the removal of tables
CREATE TRIGGER PreventTableDeletion
ON DATABASE
FOR DROP_TABLE
AS
	RAISERROR ('You are not allowed to remove tables from this database.', 16, 1);
    ROLLBACK;
    
2.13. Logon triggers - Video
2.14. Enhancing database security
Recently, several inconsistencies have been discovered on the Fresh Fruit Delivery company's database server.

The IT Security team does not have an auditing process to find out 
when users are connecting to the database and track breaking changes back to the responsible user.
You are asked to help the Security team by implementing a new trigger based on their requirements.

Due to the complexity of this request, you should build the INSERT statement in the first step 
and use it to create the trigger in the second step.

 Create the INSERT statement that is going to fill in user details in the ServerLogonLog table.
 Select only the details for the situation when the session_id is the same as the @@SPID (ID of the current user).

-- Save user details in the audit table
INSERT INTO ServerLogonLog (LoginName, LoginDate, SessionID, SourceIPAddress)
SELECT ORIGINAL_LOGIN(), GETDATE(), @@SPID, client_net_address
-- The user details can be found in SYS.DM_EXEC_CONNECTIONS
FROM SYS.DM_EXEC_CONNECTIONS WHERE session_id = @@SPID;

  Create a new trigger at the server level that fires for logon events and saves user details into ServerLogonLog table.

-- Create a trigger firing when users log on to the server
CREATE TRIGGER LogonAudit
-- Use ALL SERVER to create a server-level trigger
ON ALL SERVER WITH EXECUTE AS 'sa'
-- The trigger should fire after a logon
AFTER LOGON
AS
	-- Save user details in the audit table
	INSERT INTO ServerLogonLog (LoginName, LoginDate, SessionID, SourceIPAddress)
	SELECT ORIGINAL_LOGIN(), GETDATE(), @@SPID, client_net_address
	FROM SYS.DM_EXEC_CONNECTIONS WHERE session_id = @@SPID;
  
2.15. Defining a logon trigger
Which characteristics can be set when creating a logon trigger?
---> The trigger name / The set of actions to be performed

3. Trigger Limitations and Use Cases
Find out known limitations of triggers, as well as common use cases for AFTER triggers (DML), INSTEAD OF triggers (DML) and DDL triggers.

3.1. Known limitations of triggers
3.2. Trigger limitations
What are some known trigger limitations?
---> Triggers are invisible to client applications and difficult to debug.
---> Triggers are difficult to test and troubleshoot when they are too complex.
---> Triggers can degrade the server's performance when overused.
 
3.3. Creating a report on existing triggers
Taking on the responsibility of administrating the database for the Fresh Fruit Delivery company also means keeping an eye on existing triggers.

The best approach is to have a report that can be run regularly and outputs details of the existing triggers.
This will ensure you have a good overview of the triggers and give you access to some interesting information.

 Start creating the triggers report by gathering information about existing database triggers from the sys.triggers table.

-- Get the column that contains the trigger name
SELECT name AS TriggerName,
	   parent_class_desc AS TriggerType,
	   create_date AS CreateDate,
	   modify_date AS LastModifiedDate,
	   is_disabled AS Disabled,
       -- Get the column that tells if it's an INSTEAD OF trigger
	   is_instead_of_trigger AS InsteadOfTrigger
FROM sys.triggers;

Include information about existing server-level triggers from the sys.server_triggers table and order by trigger name.

-- Gather information about database triggers
SELECT name AS TriggerName,
	   parent_class_desc AS TriggerType,
	   create_date AS CreateDate,
	   modify_date AS LastModifiedDate,
	   is_disabled AS Disabled,
	   is_instead_of_trigger AS InsteadOfTrigger
FROM sys.triggers
UNION ALL
SELECT name AS TriggerName,
	   -- Get the column that contains the trigger type
	   parent_class_desc AS TriggerType,
	   create_date AS CreateDate,
	   modify_date AS LastModifiedDate,
	   is_disabled AS Disabled,
	   0 AS InsteadOfTrigger
-- Gather information about server triggers
FROM sys.server_triggers
-- Order the results by the trigger name
ORDER BY TriggerName;

Enhance the report by including the trigger definitions. You can get a trigger's definition using the OBJECT_DEFINITION function.

-- Gather information about database triggers
SELECT name AS TriggerName,
	   parent_class_desc AS TriggerType,
	   create_date AS CreateDate,
	   modify_date AS LastModifiedDate,
	   is_disabled AS Disabled,
	   is_instead_of_trigger AS InsteadOfTrigger,
       -- Get the trigger definition by using a function
	   OBJECT_DEFINITION (object_id)
FROM sys.triggers
UNION ALL
-- Gather information about server triggers
SELECT name AS TriggerName,
	   parent_class_desc AS TriggerType,
	   create_date AS CreateDate,
	   modify_date AS LastModifiedDate,
	   is_disabled AS Disabled,
	   0 AS InsteadOfTrigger,
       -- Get the trigger definition by using a function
	   OBJECT_DEFINITION (object_id)
FROM sys.server_triggers
ORDER BY TriggerName;

3.4. Use cases for AFTER triggers (DML) - Video
3.5. Keeping a history of row changes
The Fresh Fruit Delivery company needs to track changes made to the Customers table.

You are asked to create a new trigger that covers any statements modifying rows in the table.

 Create a new trigger called CopyCustomersToHistory.
 Attach the trigger to the Customers table.
 Fire the trigger when rows are added or modified.
 Extract the information from the inserted special table.

-- Create a trigger to keep row history
CREATE TRIGGER CopyCustomersToHistory
ON Customers
-- Fire the trigger for new and updated rows
AFTER INSERT, UPDATE
AS
	INSERT INTO CustomersHistory (CustomerID, Customer, ContractID, ContractDate, Address, PhoneNo, Email, ChangeDate)
	SELECT CustomerID, Customer, ContractID, ContractDate, Address, PhoneNo, Email, GETDATE()
    -- Get info from the special table that keeps new rows
    FROM inserted;

Hints:
Have the trigger CopyCustomersToHistory fire for both INSERT and UPDATE statements.
Make use of the inserted special table to add information to CustomersHistory.

3.6. Table auditing using triggers
The company has decided to keep track of changes made to all the most important tables. One of those tables is Orders.

Any modification made to the content of Orders should be inserted into TablesAudit.

 Create a new AFTER trigger on the Orders table.
 Set the trigger to fire for INSERT, UPDATE, and DELETE statements.

-- Add a trigger that tracks table changes
CREATE TRIGGER OrdersAudit
ON Orders
AFTER INSERT, UPDATE, DELETE
AS
	DECLARE @Insert BIT = 0;
	DECLARE @Delete BIT = 0;	
	IF EXISTS (SELECT * FROM inserted) SET @Insert = 1;
	IF EXISTS (SELECT * FROM deleted) SET @Delete = 1;
	INSERT INTO TablesAudit (TableName, EventType, UserAccount, EventDate)
	SELECT 'Orders' AS TableName
	       ,CASE WHEN @Insert = 1 AND @Delete = 0 THEN 'INSERT'
				 WHEN @Insert = 1 AND @Delete = 1 THEN 'UPDATE'
				 WHEN @Insert = 0 AND @Delete = 1 THEN 'DELETE'
				 END AS Event
		   ,ORIGINAL_LOGIN() AS UserAccount
		   ,GETDATE() AS EventDate;
       
3.7. Use cases for INSTEAD OF triggers (DML) - Video
3.8. Preventing changes to Products
The Fresh Fruit Delivery company doesn't want regular users to be able to change product information or the actual stock.

 Create a new trigger, PreventProductChanges, that prevents any updates to the Products table.

-- Prevent any product changes
CREATE TRIGGER PreventProductChanges
ON Products
INSTEAD OF UPDATE
AS
	RAISERROR ('Updates of products are not permitted. Contact the database administrator if a change is needed.', 16, 1);
  
3.9. Checking stock before placing orders
On multiple occasions, customers have placed orders for products when the company didn't have enough stock to fulfill the orders.

This issue can be easily fixed by adding a new trigger with conditional logic for its actions.
The trigger should fire when new rows are added to the Orders table 
and check if the company has sufficient stock of the specified products to fulfill those orders.

If there is sufficient stock, the trigger will then perform the same INSERT operation like the one that fired it—only this time, 
the values will be taken from the inserted special table.

 Add a new trigger that fires for INSERT statements and checks if the order quantity can be fulfilled by the current stock.
 Raise an error if there's insufficient stock. Otherwise, perform an INSERT by making use of the inserted special table.
 
-- Create a new trigger to confirm stock before ordering
CREATE TRIGGER ConfirmStock
ON Orders
INSTEAD OF INSERT
AS
	IF EXISTS (SELECT *
			   FROM Products AS p
			   INNER JOIN inserted AS i ON i.Product = p.Product
			   WHERE p.Quantity < i.Quantity)
	BEGIN
		RAISERROR ('You cannot place orders when there is no stock for the product.', 16, 1);
	END
	ELSE
	BEGIN
		INSERT INTO Orders (OrderID, Customer, Product, Price, Currency, Quantity, WithDiscount, Discount, OrderDate, TotalAmount, Dispatched)
		SELECT OrderID, Customer, Product, Price, Currency, Quantity, WithDiscount, Discount, OrderDate, TotalAmount, Dispatched FROM inserted;
	END;
  
  
3.10. Use cases for DDL triggers - Video
3.11. Database auditing
Your next task is to develop a new trigger to audit database object changes.

You need to create the trigger at the database level. 
You can use the DDL_TABLE_VIEW_EVENTS group event to fire the trigger. 
This group event includes any database operation involving tables, views, indexes, or statistics. 
By using the group event, you do not need to specify all the events individually.

The trigger will insert details about the firing statement (event, user, query, etc.) into the DatabaseAudit table.

 Create a DatabaseAudit trigger on the database that fires for DDL_TABLE_VIEW_EVENTS.
 
-- Create a new trigger
CREATE TRIGGER DatabaseAudit
-- Attach the trigger at the database level
ON DATABASE
-- Fire the trigger for all tables/ views events
FOR DDL_TABLE_VIEW_EVENTS
AS
	-- Add details to the specified table
	INSERT INTO DatabaseAudit (EventType, DatabaseName, SchemaName, Object, ObjectType, UserAccount, Query, EventTime)
	SELECT EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'NVARCHAR(50)') AS EventType
		  ,EVENTDATA().value('(/EVENT_INSTANCE/DatabaseName)[1]', 'NVARCHAR(50)') AS DatabaseName
		  ,EVENTDATA().value('(/EVENT_INSTANCE/SchemaName)[1]', 'NVARCHAR(50)') AS SchemaName
		  ,EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(100)') AS Object
		  ,EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]', 'NVARCHAR(50)') AS ObjectType
		  ,EVENTDATA().value('(/EVENT_INSTANCE/LoginName)[1]', 'NVARCHAR(100)') AS UserAccount
		  ,EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]', 'NVARCHAR(MAX)') AS Query
		  ,EVENTDATA().value('(/EVENT_INSTANCE/PostTime)[1]', 'DATETIME') AS EventTime;
      
      
3.12. Preventing server changes
The company is also asking you to find a method to prevent databases from being mistakenly deleted by employees.
After a detailed analysis, you decide to use a trigger to fulfill the request.
The trigger will roll back any attempts to delete databases.

 Create a new trigger called PreventDatabaseDelete.
 Attach the trigger at the server level.
 
-- Create a trigger to prevent database deletion
CREATE TRIGGER PreventDatabaseDelete
-- Attach the trigger at the server level
ON ALL SERVER
FOR DROP_DATABASE
AS
   PRINT 'You are not allowed to remove existing databases.';
   ROLLBACK;

4. Trigger Optimization and Management
Learn to delete and modify triggers. Acquaint yourself with the way trigger management is done. 
Learn how to investigate problematic triggers in practice.

4.1. Deleting and altering triggers - Video
4.2. Removing unwanted triggers
After some time, the Fresh Fruit Delivery company notices that some of the triggers they requested are no longer needed. 
Their workflow has changed and not all of the triggers are used now.

It's a good practice to have your database clean and up-to-date. 
Unused objects should always be removed after proper confirmation from the involved parties.

The company calls to ask you to help them remove the unused triggers.

 Remove the PreventNewDiscounts trigger attached to the Discounts table.
 Remove the PreventTableDeletion trigger attached to the database.
 Remove the DisallowLinkedServers trigger attached at the server level.

-- Remove the trigger
DROP TRIGGER PreventNewDiscounts;

-- Remove the database trigger
DROP TRIGGER PreventTableDeletion
ON DATABASE;

-- Remove the server trigger
DROP TRIGGER DisallowLinkedServers
ON ALL SERVER;

4.3. Modifying a trigger's definition
A member of the Sales team has noticed that one of the triggers attached to the Discounts table is showing a message with the word "allowed" missing.

 Modify the trigger definition and fix the typo without dropping and recreating the trigger.
 Add the missing word to the PRINT statement.
 
-- Fix the typo in the trigger message
ALTER TRIGGER PreventDiscountsDelete
ON Discounts
INSTEAD OF DELETE
AS
	PRINT 'You are not allowed to remove data from the Discounts table.';
  
4.4. Disabling a trigger
Fresh Fruit Delivery needs to make some changes to a couple of rows in the Orders table.

Earlier they asked for a trigger to prevent unwanted changes to the Orders table, 
but now that trigger is stopping them from making the necessary modifications.

You are asked to help them with the situation by temporarily stopping that trigger from firing.

 Pause the trigger execution to allow the company to make the changes.

-- Pause the trigger execution
DISABLE TRIGGER PreventOrdersUpdate
ON Orders;

4.5. Re-enabling a disabled trigger
You helped the company update the Orders table by disabling the PreventOrdersUpdate trigger. 
Now they want the trigger to be active again to ensure no unwanted modifications are made to the table.

 Re-enable the disabled PreventOrdersUpdate trigger attached to the Orders table.
-- Resume the trigger execution
ENABLE TRIGGER PreventOrdersUpdate
ON Orders;

4.6. Trigger management - Video
4.7. Managing existing triggers
Fresh Fruit Delivery has asked you to act as the main administrator of their database.

A best practice when taking over an existing database is to get familiar with all the existing objects.

You'd like to start by looking at the existing triggers.

 Get the name, object_id, and parent_class_desc for all the disabled triggers.
 Get the unmodified server-level triggers.
 An unmodified trigger's create date is the same as the modify date.
 Use sys.triggers to extract information only about database-level triggers.
-- Get the disabled triggers
SELECT name,
	   object_id,
	   parent_class_desc
FROM sys.triggers
WHERE is_disabled = 1;

-- Check for unchanged server triggers
SELECT *
FROM sys.server_triggers
WHERE create_date = modify_date;

-- Get the database triggers
SELECT *
FROM sys.triggers
WHERE parent_class_desc = 'DATABASE';

4.8. Counting the AFTER triggers
During your analysis of the database, you decide you'd like to have an overview of how many AFTER triggers exist.
You use the sys.triggers view to count the AFTER triggers.
How many triggers are there? ---> 11 AFTER triggers

4.9. Troubleshooting triggers - Video
4.10. Keeping track of trigger executions
One important factor when monitoring triggers is to have a history of their execution. 
This allows you to associate the timings between trigger runs and any issues that occur in the database.

If the times match, it's possible that the problems were caused by the trigger.

SQL Server provides information about the execution of any triggers that are currently stored in memory in the sys.dm_exec_trigger_stats view. 
But once a trigger is removed from the memory, any information about it is removed from the view as well, so you lose the trigger execution history.

To overcome this limitation, you decide to make use of the TriggerAudit table to store information about any attempts to modify rows in the Orders table, 
because people have reported the table is often unresponsive.

 Modify the PreventOrdersUpdate trigger.
 Set the trigger to fire when rows are updated in the Orders table.
 Add additional details about the trigger execution into the TriggerAudit table.

-- Modify the trigger to add new functionality
ALTER TRIGGER PreventOrdersUpdate
ON Orders

-- Prevent any row changes
INSTEAD OF UPDATE
AS
	-- Keep history of trigger executions
	INSERT INTO TriggerAudit (TriggerName, ExecutionDate)
	SELECT 'PreventOrdersUpdate', 
           GETDATE();

	RAISERROR ('Updates on "Orders" table are not permitted.
                Place a new order to add new products.', 16, 1);
                
4.11. Identifying problematic triggers
You've identified an issue when placing new orders in the company's sales system.

The issue is related to a trigger run, but you don't have many details on the triggers themselves. 
Unfortunately, the database objects (including triggers) are not documented.

You need to identify the trigger that's causing the problem to proceed with the investigation. 
To be sure, you need to gather some important details about the triggers.

The only information you have when starting the investigation is that the table related to the issues is Orders.

  Find the ID of the Orders table by using the sys.objects system view.
-- Get the table ID
SELECT object_id AS TableID
FROM sys.objects
WHERE name = 'Orders';

  Find all the triggers attached to the Orders table by joining the first query with sys.triggers.
-- Get the trigger name
SELECT t.name AS TriggerName
FROM sys.objects AS o
-- Join with the triggers table
INNER JOIN sys.triggers AS t ON t.parent_id = o.object_id
WHERE o.name = 'Orders';
  
  Filter the triggers fired for UPDATE statements, joining the previous query with sys.trigger_events.
  Select the triggers and their firing statements by matching the object_id columns from sys.triggers and sys.trigger_events.
SELECT t.name AS TriggerName
FROM sys.objects AS o
INNER JOIN sys.triggers AS t ON t.parent_id = o.object_id
-- Get the trigger events
INNER JOIN sys.trigger_events AS te ON te.object_id = t.object_id
WHERE o.name = 'Orders'
-- Filter for triggers reacting to new rows
AND te.type_desc = 'UPDATE';

  Include the trigger definitions in your selection with the use of a standard SQL Server function.
SELECT t.name AS TriggerName,
	   OBJECT_DEFINITION(t.object_id) AS TriggerDefinition
FROM sys.objects AS o
INNER JOIN sys.triggers AS t ON t.parent_id = o.object_id
INNER JOIN sys.trigger_events AS te ON te.object_id = t.object_id
WHERE o.name = 'Orders'
AND te.type_desc = 'UPDATE';


4.12. Wrapping up - Video

