INSERT INTO Shares
			SELECT Owner , 3 , 1 , 8 , 0 , 33.5 , 0 , 0
            FROM Shares
            WHERE Treatment = 3 AND [Group#] = 1 AND [Period] = 2 AND Choice = 0;


EXEC Winning 3, 1, 6, 2;

UPDATE People SET FinalBalance = 5.4 WHERE Treatment = 3;

UPDATE People SET FinalBalance = Balance - 5 + (109560.0/1000000.0) * 
        COALESCE((SELECT Volume FROM Shares WHERE Owner = People.ID AND Period = 8 AND Choice = 0),0)
        WHERE Treatment = 2 AND Group# = 1;