SELECT Period, Choice, SUM(Vol*Price) AS VolPerPeriod FROM Transactions
WHERE Treatment = 0
GROUP BY Period, Choice
ORDER BY Period, Choice

SELECT 
DATEDIFF(SECOND, Verified, QualificationTime) AS Duration2Qualify, 
DATEDIFF(SECOND, QualificationTime, '2019-07-07 19:00:00') AS Duration2Start,
DATEDIFF(SECOND, '2019-07-07 19:50:00', Completed) AS Duration2End,
*,
(SELECT sum(Vol*Price) FROM Transactions 
WHERE Buyer=ID)AS BuyVolume,
(SELECT sum(Vol*Price) FROM Transactions 
WHERE Buyer=ID AND Period<5)AS BuyVolumeEarly,
(SELECT sum(Vol*Price) FROM Transactions 
WHERE Buyer=ID AND Period>7)AS BuyVolumeLate,

(SELECT sum(Vol*Price)  FROM Transactions 
WHERE Seller=ID)AS SellVolume,
(SELECT sum(Vol*Price)  FROM Transactions 
WHERE Seller=ID AND Period<5)AS SellVolumeEarly,
(SELECT sum(Vol*Price)  FROM Transactions 
WHERE Seller=ID AND Period>7)AS SellVolumeLate

FROM People
WHERE Treatment = 0 AND Group# = 1 ;