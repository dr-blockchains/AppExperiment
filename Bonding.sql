-- =============================================
-- Author:		<Dr Hamed Khaledi>
-- Create date: <2018>
-- Description:	<Parallel Bonding>
-- =============================================

CREATE PROCEDURE [dbo].[Bonding]
( 
	@Treatment INT, 
	@Group INT,
	@Period INT, 
	@Choice INT, 
	@Bidder NVARCHAR(50),
	@Buy0Sell1 BIT,
	@Shares1Rounded FLOAT,
	@DShare FLOAT
)
AS
BEGIN TRANSACTION


--**************************** Shares1 / Shares2 / Price1 / Price2 / dfund ***********************
BEGIN TRY

	IF (@DShare <= 0 OR @DShare > 10000 OR @Shares1Rounded <0 OR @Shares1Rounded > 1000) 
	BEGIN
		ROLLBACK TRANSACTION;
		INSERT INTO ErrorLog VALUES (GETDATE(),20, 'Out of Range', 2);
		RETURN 20;
	END;

	DECLARE @A FLOAT, @B FLOAT, @Price1 FLOAT, @Shares1 FLOAT, @Shares2 FLOAT, @DFund FLOAT;

	SELECT @Shares1 = Score
		FROM Versions
		WHERE (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);

	IF ABS(@Shares1 - @Shares1Rounded) > .01 
	BEGIN
		ROLLBACK TRANSACTION;
		INSERT INTO ErrorLog VALUES (GETDATE(),30, 'Price Changed: Difference=' + CAST(@Shares1 - @Shares1Rounded AS VARCHAR), 3);
		RETURN 30;
	END;

	SELECT @A = A , @B = B FROM Groups 
	WHERE (Treatment = @Treatment) AND([Group#] = @Group);

--	SET @A = 1; SET @B = 1;

	SET @Price1 = @A*@Shares1 + @B;

END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;
	INSERT INTO ErrorLog VALUES (GETDATE(),ERROR_NUMBER(), ERROR_MESSAGE(), 4);		
	RETURN ERROR_NUMBER();
END CATCH	


--**************************** OFFER / Order / TRANSACTION ***********************
BEGIN TRY
	INSERT INTO Offers VALUES (@Treatment, @Group, @Period, @Choice, @Bidder, GETDATE(), @Price1, @DShare, 0, @Buy0Sell1);
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;
	INSERT INTO ErrorLog VALUES (GETDATE(),ERROR_NUMBER(), ERROR_MESSAGE(), 1);
	--PRINT  CAST(ERROR_NUMBER() AS VARCHAR) + ' Error in Order: ' + ERROR_MESSAGE();
	RETURN ERROR_NUMBER();
END CATCH;



IF @Buy0Sell1 = 0
--*****************************BUYER********************************
BEGIN
BEGIN TRY
	SET @Shares2 = @Shares1 + @DShare;
	SET @DFund = @DShare * ( .5 * @A * (@Shares1 + @Shares2) + @B);

	DECLARE @Deficit FLOAT;
	SELECT @Deficit = @DFund - BalanceConfirm
	FROM Shares 
	WHERE ([Owner] = @Bidder) AND (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);

	DECLARE @AvFund FLOAT;
	SELECT @AvFund = Balance FROM People WHERE ID=@Bidder;

	IF @Deficit IS NULL
	BEGIN
		IF @AvFund < @DFund
		BEGIN
			SET @DFund = @AvFund;
			SET @Shares2 = (-@B + SQRT(@Price1 *@Price1 + 2 * @A * @DFund) ) / @A;
			SET @DShare = @Shares2 - @Shares1;
		END;
		INSERT INTO Shares VALUES (@Bidder, @Treatment, @Group, @Period, @Choice, @DShare, 0, @DFund);
		UPDATE People SET Balance = Balance -  @DFund WHERE ID = @Bidder;
	END 
	ELSE IF	@Deficit <= 0
	BEGIN -- No Money Transfer From People.Balance				
		UPDATE Shares SET BalanceConfirm = -@Deficit, Volume = Volume + @DShare WHERE ([Owner] = @Bidder) AND (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);
	END
	ELSE
	BEGIN -- With Money Transfer From People.Balance
		IF @AvFund < @Deficit
		BEGIN
			SET @DFund += @AvFund - @Deficit;
			SET @Deficit = @AvFund;
			SET @Shares2 = (-@B + SQRT(@Price1 *@Price1 + 2 * @A * @DFund) ) / @A;
			SET @DShare = @Shares2 - @Shares1;
		END;
		UPDATE People SET Balance = Balance - @Deficit WHERE ID = @Bidder; 
		UPDATE Shares SET BalanceConfirm = 0, BalanceVoid = BalanceVoid + @Deficit , Volume = Volume + @DShare 
			WHERE ([Owner] = @Bidder) AND (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);
	END;
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;
	INSERT INTO ErrorLog VALUES (GETDATE(),ERROR_NUMBER(), ERROR_MESSAGE(), 5);		
	RETURN ERROR_NUMBER();	
END CATCH	

END
ELSE	
--****************************SELLER ******************************
BEGIN
BEGIN TRY
	DECLARE @AvShare FLOAT;
	SELECT @AvShare = Volume FROM Shares
	WHERE ([Owner] = @Bidder) AND (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);

	IF @AvShare < @DShare
	BEGIN
		SET @DShare = @AvShare;
	END;
		
	SET @Shares2 = @Shares1 - @DShare;
	SET @DFund = @DShare * ( .5 * @A * (@Shares1 + @Shares2) + @B);

	UPDATE Shares SET BalanceConfirm = BalanceConfirm + @DFund, Volume = Volume - @DShare WHERE ([Owner] = @Bidder) AND (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);

	DECLARE @MinB FLOAT;

	-- A choice will be voided or confirmed.
	SELECT @MinB = CASE WHEN BalanceVoid > BalanceConfirm THEN BalanceConfirm ELSE BalanceVoid END
		FROM Shares
		WHERE ([Owner] = @Bidder) AND (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);
	IF @MinB > 0
	BEGIN
		UPDATE Shares
		SET BalanceConfirm = BalanceConfirm - @MinB , BalanceVoid = BalanceVoid - @MinB
		WHERE ([Owner] = @Bidder) AND (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);

		UPDATE People
		SET Balance = Balance + @MinB
		WHERE ([ID] = @Bidder)
	END;

	-- One choice will be confirmed.
	SELECT @MinB = MIN(BalanceConfirm)
		FROM Shares
		WHERE ([Owner] = @Bidder) AND (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period);
				
	IF @MinB > 0
	BEGIN
		UPDATE Shares
		SET BalanceConfirm = BalanceConfirm - @MinB
		WHERE ([Owner] = @Bidder) AND (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period);

		UPDATE People
		SET Balance = Balance + @MinB
		WHERE ([ID] = @Bidder)
	END;

END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;
	INSERT INTO ErrorLog VALUES (GETDATE(),ERROR_NUMBER(), ERROR_MESSAGE(), 6);
	RETURN ERROR_NUMBER();
END CATCH	

END; -- ELSE

--**************************** UPDATE Total Shares & Price ******************************
BEGIN TRY
	UPDATE Versions SET Score = (@Shares2) WHERE (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;
	INSERT INTO ErrorLog VALUES (GETDATE(),ERROR_NUMBER(), ERROR_MESSAGE(), 7);
	RETURN ERROR_NUMBER();
END CATCH

COMMIT TRANSACTION;
RETURN 1;