DECLARE @TID INT = 1;

DELETE FROM Shares WHERE Treatment = @TID AND Period > 2;

UPDATE Shares SET Volume = 0 , BalanceConfirm = 0 , BalanceVoid = 0 WHERE Treatment = @TID AND Period = 2;

SELECT * FROM Shares WHERE Treatment = @TID;

UPDATE People SET Balance = 100 , ShareBalance = 0 , FinalBalance = 0 , Completed = NULL WHERE Treatment = @TID;

SELECT * FROM People WHERE Treatment = @TID;

UPDATE Versions SET Score = 0 WHERE Treatment = @TID;

UPDATE Groups SET Period = 0, Starting =  DATEADD(MINUTE, 10, GETDATE()), DT =  DATEADD(MINUTE, 10, GETDATE())  WHERE Treatment = @TID;