DECLARE @SumShares FLOAT;
	SELECT @SumShares = SUM(Volume) FROM Shares
		WHERE (Treatment = 1) AND([Group#] = 1) AND (Period = 2) AND (Choice = 3);

