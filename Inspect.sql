SELECT Score, Score + 1 AS Price , .5*Score*Score + Score AS Fund FROM Versions
WHERE Treatment = 1 AND Group# = 1;

SELECT Period, Choice, SUM(BalanceVoid) AS FundRaised , SUM(BalanceConfirm) AS FundReturned , SUM(Volume) AS [Total Shares Outstanding] FROM Shares
WHERE Treatment = 1 AND Group# = 1
GROUP BY Period, Choice;


