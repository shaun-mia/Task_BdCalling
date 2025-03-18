
-- 1. Identify relationships among all tables
SELECT 
    fk.name AS ForeignKeyName,
    tp.name AS ParentTable,
    cp.name AS ParentColumn,
    tr.name AS ReferencedTable,
    cr.name AS ReferencedColumn
FROM sys.foreign_keys AS fk
INNER JOIN sys.tables AS tp ON fk.parent_object_id = tp.object_id
INNER JOIN sys.tables AS tr ON fk.referenced_object_id = tr.object_id
INNER JOIN sys.foreign_key_columns AS fkc ON fk.object_id = fkc.constraint_object_id
INNER JOIN sys.columns AS cp ON fkc.parent_column_id = cp.column_id AND fkc.parent_object_id = cp.object_id
INNER JOIN sys.columns AS cr ON fkc.referenced_column_id = cr.column_id AND fkc.referenced_object_id = cr.object_id;

-- 2. Determine total unique customers
SELECT COUNT(DISTINCT [Customer Number]) AS UniqueCustomers FROM Customers;

-- 3. Calculate occupancy rate
SELECT 
    SUM([Number of Adults] + [Number of Children]) * 100.0 / SUM([Maximum Occupancy]) AS OccupancyRate
FROM Reservations
JOIN Hotel_Rooms ON Reservations.[Room Number] = Hotel_Rooms.[Room Number];

-- 4. Analyze distribution of customer complaints room-wise
SELECT 
    Reservations.[Room Number], COUNT(Tickets.[Ticket ID]) AS ComplaintCount
FROM Tickets
JOIN Reservations ON Tickets.[Reservation ID] = Reservations.[Reservation ID]
GROUP BY Reservations.[Room Number]
ORDER BY ComplaintCount DESC;

-- 5. Identify key complaints in customer feedback
SELECT [Ticket Category], COUNT(*) AS ComplaintCount
FROM Tickets
GROUP BY [Ticket Category]
ORDER BY ComplaintCount DESC;

-- 6. Calculate customer retention rate
WITH ReturningCustomers AS (
    SELECT [Customer Number], COUNT([Reservation ID]) AS VisitCount
    FROM Reservations
    GROUP BY [Customer Number]
    HAVING COUNT([Reservation ID]) > 1
)
SELECT COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Customers) AS RetentionRate FROM ReturningCustomers;

-- 7. Identify total complaints for each room
SELECT Reservations.[Room Number], COUNT(Tickets.[Ticket ID]) AS TotalComplaints
FROM Tickets
JOIN Reservations ON Tickets.[Reservation ID] = Reservations.[Reservation ID]
GROUP BY Reservations.[Room Number];

-- 8. Region-wise breakdown of offers sent and customer engagement
SELECT Customers.[Residence], COUNT(Tickets.[Ticket ID]) AS EngagementCount
FROM Customers
LEFT JOIN Reservations ON Customers.[Customer Number] = Reservations.[Customer Number]
LEFT JOIN Tickets ON Reservations.[Reservation ID] = Tickets.[Reservation ID]
GROUP BY Customers.[Residence]
ORDER BY EngagementCount DESC;

-- 9. Calculate revenue for each room
SELECT Reservations.[Room Number], SUM(Reservations.Price) AS TotalRevenue
FROM Reservations
GROUP BY Reservations.[Room Number]
ORDER BY TotalRevenue DESC;