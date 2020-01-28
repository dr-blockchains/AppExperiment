DECLARE @TID INT = 1;

SELECT * FROM Groups
WHERE Treatment = @TID;

SELECT * FROM Versions
WHERE Treatment = @TID;

SELECT * FROM People
WHERE Treatment = @TID;

SELECT * FROM Shares
WHERE Treatment = @TID;

SELECT * FROM Orders
WHERE Treatment = @TID;

SELECT * FROM ErrorLog;
