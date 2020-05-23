DECLARE @WorkerID VARCHAR(50);
SET @WorkerID = 'ACGZDI611LU0I';

SELECT ID, FinalBalance - 5, Balance + ShareBalance - 5, Education, Before5, After2R
FROM People 
WHERE ID LIKE @WorkerID;

UPDATE People SET Name = Name + '***' WHERE ID = @WorkerID;

SELECT * FROM Offers
WHERE Bidder = @WorkerID;