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
	@Time DATETIME,
	@Buy0Sell1 BIT,
	@Price FLOAT,
	@DShare FLOAT
)
AS
BEGIN TRANSACTION

--**************************** OFFER / Order / TRANSACTION ***********************
BEGIN TRY
	INSERT INTO Offers VALUES (@Treatment, @Group, @Period, @Choice, @Bidder, @Time, @Price, @DShare, 0, @Buy0Sell1);
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;
	INSERT INTO ErrorLog VALUES (GETDATE(),ERROR_NUMBER(), ERROR_MESSAGE(), 1);
	--PRINT  CAST(ERROR_NUMBER() AS VARCHAR) + ' Error in Order: ' + ERROR_MESSAGE();
	RETURN ERROR_NUMBER();
END CATCH;

--**************************** Shares1 / Shares2 / Price1 / Price2 / dfund ***********************
BEGIN TRY

	IF (@DShare <= 0 OR @DShare > 10000 OR @Price <0 OR @Price > 1000) 
	BEGIN
		ROLLBACK TRANSACTION;
		INSERT INTO ErrorLog VALUES (GETDATE(),ERROR_NUMBER(), ERROR_MESSAGE(), 9);
		--PRINT  CAST(ERROR_NUMBER() AS VARCHAR) + ' Error in Order: ' + ERROR_MESSAGE();
		RETURN ERROR_NUMBER();
	END;

	DECLARE @Price1 FLOAT, @Shares1 FLOAT, @Shares2 FLOAT, @DFund FLOAT;

	SELECT @Price1 = Score
		FROM Versions
		WHERE (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);

	IF @Price1 <> @Price 
	BEGIN
		ROLLBACK TRANSACTION;
		INSERT INTO ErrorLog VALUES (GETDATE(),ERROR_NUMBER(), ERROR_MESSAGE(), 8);
		--PRINT  CAST(ERROR_NUMBER() AS VARCHAR) + ' Error in Order: ' + ERROR_MESSAGE();
		RETURN ERROR_NUMBER();
	END;
	SET @Shares1 = @Price1 * 100.0;

END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;
	INSERT INTO ErrorLog VALUES (GETDATE(),ERROR_NUMBER(), ERROR_MESSAGE(), 2);		
	RETURN ERROR_NUMBER();
	--PRINT  CAST(ERROR_NUMBER() AS VARCHAR) + ' Did not INSERT for Buyer: ' + ERROR_MESSAGE();
END CATCH	

IF @Buy0Sell1 = 0
--*****************************BUYER********************************
BEGIN
	SET @Shares2 = @Shares1 + @DShare;

	SET @DFund = @DShare * (@Shares1 + @Shares2) / 200;

BEGIN TRY
	DECLARE @Deficit FLOAT;
	SELECT @Deficit = @DFund - BalanceConfirm 
	FROM Shares 
	WHERE ([Owner] = @Bidder) AND (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);

	DECLARE @NewBalance FLOAT;
	SELECT 

	IF @Deficit IS NULL
	BEGIN
		INSERT INTO Shares VALUES (@Bidder, @Treatment, @Group, @Period, @Choice, @DShare, 0, @DFund);
		UPDATE People SET Balance = Balance -  @DFund WHERE ID = @Bidder;
		RETURN 2;
	END
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;
	INSERT INTO ErrorLog VALUES (GETDATE(),ERROR_NUMBER(), ERROR_MESSAGE(), 4);		
	RETURN ERROR_NUMBER();
	--PRINT  CAST(ERROR_NUMBER() AS VARCHAR) + ' Did not INSERT for Buyer: ' + ERROR_MESSAGE();
	--IF ERROR_NUMBER() = 2627		
END CATCH	

--Updates existing shares balances.
BEGIN TRY
	IF @Deficit <= 0
	BEGIN -- No Money Transfer From People.Balance				
		--PRINT 'Deficit <= 0';
		UPDATE Shares SET BalanceConfirm = -@Deficit, Volume = Volume + @DShare WHERE ([Owner] = @Bidder) AND (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);
	END
	ELSE
	BEGIN -- With Money Transfer From People.Balance
		--PRINT 'Deficit > 0';
		UPDATE People SET Balance = Balance - @Deficit WHERE ID = @Bidder; 
		UPDATE Shares SET BalanceConfirm = 0, BalanceVoid = BalanceVoid + @Deficit , Volume = Volume + @DShare 
			WHERE ([Owner] = @Bidder) AND (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);
	END;
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;
	INSERT INTO ErrorLog VALUES (GETDATE(),ERROR_NUMBER(), ERROR_MESSAGE(), 5);
	--PRINT CAST(ERROR_NUMBER() AS VARCHAR) + ' UPDATE Buyer: ' + ERROR_MESSAGE() ;
	RETURN ERROR_NUMBER(); -- 547 : Buyer does not have enough Balance
END CATCH;

END
ELSE	
--****************************SELLER ******************************

BEGIN

SET @Shares2 = @Shares1 - @DShare;
SET @DFund = @DShare * (@Shares1 + @Shares2) / 200;

BEGIN TRY
	UPDATE Shares SET BalanceConfirm = BalanceConfirm + @DFund, Volume = Volume - @DShare WHERE ([Owner] = @Bidder) AND (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);

	DECLARE @MinB FLOAT;
	SELECT @MinB = CASE WHEN BalanceVoid > BalanceConfirm THEN BalanceConfirm ELSE BalanceVoid END
		FROM Shares
		WHERE ([Owner] = @Bidder) AND (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);
				
	--PRINT 'MinB = ' + CAST(@MinB AS VARCHAR);
	
	IF @MinB > 0
	BEGIN
		--PRINT 'MinB > 0 ';

		UPDATE Shares
		SET BalanceConfirm = BalanceConfirm - @MinB , BalanceVoid = BalanceVoid - @MinB
		WHERE ([Owner] = @Bidder) AND (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);	

		UPDATE People 
		SET Balance = Balance + @MinB
		WHERE ([ID] = @Bidder)
	END;
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;
	INSERT INTO ErrorLog VALUES (GETDATE(),ERROR_NUMBER(), ERROR_MESSAGE(), 3);
	--PRINT CAST(ERROR_NUMBER() AS VARCHAR) + ' Shares Seller: ' + ERROR_MESSAGE();
	RETURN ERROR_NUMBER(); -- 547 : Seller does not have enough Shares.
END CATCH	

END; -- ELSE

BEGIN TRY

	UPDATE Versions SET Score = (@Shares2/100.0) WHERE (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);

END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;
	INSERT INTO ErrorLog VALUES (GETDATE(),ERROR_NUMBER(), ERROR_MESSAGE(), 2);
	--PRINT  CAST(ERROR_NUMBER() AS VARCHAR) + ' Error in Versions: ' + ERROR_MESSAGE();
	RETURN ERROR_NUMBER();
END CATCH

COMMIT TRANSACTION;
--PRINT 'Completed';
RETURN 1;