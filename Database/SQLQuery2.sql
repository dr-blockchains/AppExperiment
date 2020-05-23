DECLARE @WorkerID VARCHAR(50);
SET @WorkerID = 'A2ETY1O927Z1IF';

SELECT ID, FinalBalance - 5 AS Bonus, Balance + ShareBalance - 5 AS BonusAgain, Balance, ShareBalance, Education, Before5, After2R
FROM People 
WHERE ID LIKE @WorkerID;

UPDATE People SET Education = Education + '***' WHERE ID = @WorkerID;

SELECT * FROM Offers
WHERE Bidder = @WorkerID;