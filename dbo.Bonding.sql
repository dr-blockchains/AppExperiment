-- =============================================
-- Author:		<Dr Hamed Khaledi>
-- Create date: <2018>
-- Description:	<Parallel Primary Markets>
-- =============================================

CREATE PROCEDURE [dbo].[Bonding]
( 
	@Treatment INT, 
	@Group INT,
	@Period INT, 
	@Choice INT, 
	@Bidder NVARCHAR(50),
	@Shares1Rounded FLOAT,
	@DShare FLOAT
)
AS
SET XACT_ABORT ON;

BEGIN TRANSACTION

--**************************** Shares1 / Shares2 / Price1 / Price2 / dfund ***********************
BEGIN TRY

	IF (@DShare < -10000 OR @DShare > 10000 OR @DShare = 0 OR @Shares1Rounded < -10000 OR @Shares1Rounded > 10000) 
	BEGIN
		ROLLBACK TRANSACTION;
		INSERT INTO ErrorLog VALUES (GETDATE(),28, 'Out of Range', 2);
		RETURN 20;
	END;

	DECLARE @A FLOAT, @B FLOAT, @Price1 FLOAT, @Price2 FLOAT, @Shares1 FLOAT, @Shares2 FLOAT, @DFund FLOAT, @UnFull FLOAT = 0;

	SELECT @Shares1 = Score FROM Versions
		WHERE (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);

	IF ABS(@Shares1 - @Shares1Rounded) > .001 
	BEGIN
		ROLLBACK TRANSACTION;
		INSERT INTO ErrorLog VALUES (GETDATE(),41, 'Price Changed: Difference=' + CAST(@Shares1 - @Shares1Rounded AS VARCHAR), 3);
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


IF @DShare > 0
--*****************************BUYER********************************
BEGIN
BEGIN TRY
	SET @Shares2 = @Shares1 + @DShare;
	SET @DFund = @DShare * ( .5 * @A * (@Shares1 + @Shares2) + @B);

	DECLARE @Confirm FLOAT;
	SELECT @Confirm = COALESCE(BalanceConfirm,0)
	FROM Shares 
	WHERE ([Owner] = @Bidder) AND (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);	

	--IF @Confirm IS NULL -- No BalanceConfirm
	--BEGIN
	--	IF @Cash < @DFund BEGIN
	--		SET @DFund = @Cash;
	--		SET @Shares2 = (-@B + SQRT(@B * @B + @Price1 *@Price1 + 2 * @A * @DFund) ) / @A;
	--		SET @DShare = @Shares2 - @Shares1;
	--	END;

	--	UPDATE People SET Balance = Balance -  @DFund WHERE ID = @Bidder;
	--	INSERT INTO Shares VALUES (@Bidder, @Treatment, @Group, @Period, @Choice, @DShare, 0, @DFund);
		
	--END 
	--ELSE 

	IF @Confirm < @DFund -- Need Money Transfer From People.Balance
	BEGIN 
		DECLARE @EndBalance FLOAT;
		SELECT @EndBalance = Balance + @Confirm - @DFund FROM People WHERE ID=@Bidder;

		IF @EndBalance < 0 BEGIN
			SET @DFund = @DFund + @EndBalance;

			IF @DFund <= 0 BEGIN
				ROLLBACK TRANSACTION;
				INSERT INTO ErrorLog VALUES (GETDATE(),95, 'DFund decreased to: ' + CAST(@DFund AS VARCHAR) , 11);		
				RETURN ERROR_NUMBER();	
			END;

			SET @EndBalance = 0;
			SET @Shares2 = (-@B + SQRT(@Price1*@Price1 + 2 * @A * @DFund) ) / @A;
			
			SET @UnFull = @Dshare - @Shares2 + @Shares1;
			SET @DShare = @Shares2 - @Shares1;					   			 		  		  		 	   			   	 
		END;

		UPDATE People SET Balance = @EndBalance WHERE ID = @Bidder; 
		UPDATE Shares SET BalanceConfirm = 0, BalanceVoid = BalanceVoid + @DFund - @Confirm , Volume = Volume + @DShare 
			WHERE ([Owner] = @Bidder) AND (Treatment = @Treatment) AND ([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);
	END
	ELSE
	BEGIN -- No Money Transfer From People.Balance				
		UPDATE Shares SET BalanceConfirm = BalanceConfirm - @DFund, Volume = Volume + @DShare 
			WHERE ([Owner] = @Bidder) AND (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);
	END;

END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;
	INSERT INTO ErrorLog VALUES (GETDATE(),ERROR_NUMBER(), ERROR_MESSAGE(), 5);		
	RETURN ERROR_NUMBER();	
END CATCH	

END
ELSE --****************************SELLER ******************************
BEGIN
BEGIN TRY
	SET @DShare = -@DShare;

	DECLARE @AvShare FLOAT;
	SELECT @AvShare = Volume FROM Shares
		WHERE ([Owner] = @Bidder) AND (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);
	
	IF @AvShare > @Shares1 BEGIN		
		INSERT INTO ErrorLog VALUES (GETDATE(), 137, 'Av Share not match: ' + CAST((@AvShare - @Shares1) AS VARCHAR) , 9);
		IF @AvShare - @Shares1 > .01 BEGIN
			ROLLBACK TRANSACTION;
			RETURN 137;  	 
		END;

		SET @AvShare = @Shares1;

	END;
	
	IF @AvShare < @DShare BEGIN		
		SET @UnFull = @DShare - @AvShare;
		SET @DShare = @AvShare;		
		IF @DShare <= 0 BEGIN
				ROLLBACK TRANSACTION;
				INSERT INTO ErrorLog VALUES (GETDATE(),144, 'DShare decreased to: ' + CAST(@DShare AS VARCHAR) , 12);		
				RETURN ERROR_NUMBER();
		END;
	END;
		
	SET @Shares2 = @Shares1 - @DShare;
	SET @DFund = @DShare * ( .5 * @A * (@Shares1 + @Shares2) + @B);

	UPDATE Shares SET BalanceConfirm = BalanceConfirm + @DFund, Volume = Volume - @DShare 
		WHERE ([Owner] = @Bidder) AND (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);

	SET @DFund = -@DFund;

	DECLARE @MinB FLOAT;

	-- A choice will be voided or confirmed.
	SELECT @MinB = CASE WHEN BalanceVoid > BalanceConfirm THEN BalanceConfirm ELSE BalanceVoid END
		FROM Shares
		WHERE ([Owner] = @Bidder) AND (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);
	
	IF @MinB > 0
	BEGIN
		UPDATE Shares SET BalanceConfirm = BalanceConfirm - @MinB , BalanceVoid = BalanceVoid - @MinB
			WHERE ([Owner] = @Bidder) AND (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);

		UPDATE People SET Balance = Balance + @MinB
			WHERE ([ID] = @Bidder)
	END;

	-- One choice will be confirmed.
	SELECT @MinB = MIN(BalanceConfirm)
		FROM Shares	WHERE ([Owner] = @Bidder) AND (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period);
				
	IF @MinB > 0
	BEGIN
		UPDATE Shares SET BalanceConfirm = BalanceConfirm - @MinB
			WHERE ([Owner] = @Bidder) AND (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period);

		UPDATE People SET Balance = Balance + @MinB
			WHERE ([ID] = @Bidder)
	END;

END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;
	INSERT INTO ErrorLog VALUES (GETDATE(),ERROR_NUMBER(), ERROR_MESSAGE(), 6);
	RETURN ERROR_NUMBER();
END CATCH	

END; -- END ELSE

BEGIN TRY
	DECLARE @SumShares FLOAT;
	SELECT @SumShares = SUM(Volume) FROM Shares
		WHERE (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);

	IF ABS(@Shares2 - @SumShares) > .01 BEGIN
		INSERT INTO ErrorLog VALUES (GETDATE(), 209, 'Sum Shares not match: ' + CAST((@SumShares - @Shares2) AS VARCHAR) , 8);
		ROLLBACK TRANSACTION;
		RETURN 209;
	END;

	--**************************** OFFER / Order / TRANSACTION ***********************
	INSERT INTO Orders VALUES (@Treatment, @Group, @Period, @Choice, @Bidder, GETDATE(), @DShare, @UnFull, @Price1, @A*@Shares2 + @B);

	--**************************** UPDATE Total Shares & Price ******************************
	UPDATE Versions SET Score = @Shares2 , Fund = Fund + @DFund
		WHERE (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);

END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;
	INSERT INTO ErrorLog VALUES (GETDATE(),ERROR_NUMBER(), ERROR_MESSAGE(), 7);
	RETURN ERROR_NUMBER();
END CATCH

COMMIT TRANSACTION;
RETURN 1;