SELECT Versions.Choice, Score, Price,  UnFullfilled FROM Versions LEFT JOIN (SELECT * FROM Offers WHERE Buy0Sell1 = 0 AND UnFullfilled > 0) AS Offers1
ON Versions.Treatment = Offers1.Treatment AND Versions.Group# = Offers1.Group# AND Versions.Period= Offers1.Period AND Versions.Choice=Offers1.Choice
WHERE Versions.Treatment = 1 AND Versions.[Group#] = 1 AND Versions.Period = 6
ORDER BY Price DESC, Versions.Score DESC, Versions.Choice