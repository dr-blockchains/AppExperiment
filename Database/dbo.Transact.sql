-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Transact]
( 
	@Treatment INT, 
	@Group INT,
	@Period INT, 
	@Choice INT, 
	@Seller NVARCHAR(50),
	@Sell_Time DATETIME,
	@Buyer NVARCHAR(50),
	@Buy_Time DATETIME,
	@Price REAL,
	@Vol REAL
)
AS
BEGIN	
BEGIN TRANSACTION

--***************************TRANSACTIONS***********************
BEGIN TRY
	INSERT INTO Transactions VALUES (@Treatment, @Group, @Period, @Choice, @Seller, @Sell_Time, @Buyer, @Buy_Time, @Price, @Vol);
	--UPDATE Versions SET Score = @Price WHERE (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;
	INSERT INTO ErrorLog VALUES (GETDATE(),ERROR_NUMBER(), ERROR_MESSAGE(), 1);
	--PRINT  CAST(ERROR_NUMBER() AS VARCHAR) + ' Error in Transactions: ' + ERROR_MESSAGE();
	RETURN ERROR_NUMBER();
END CATCH;
	   
--****************************OFFERS FULLFILL***********************
BEGIN TRY
	UPDATE Offers
	SET UnFullfilled = UnFullfilled - @Vol
	WHERE (([Bidder] = @Seller AND [Time]=@Sell_Time) OR ([Bidder] = @Buyer AND [Time]=@Buy_Time)) 
		AND (Treatment = @Treatment) AND([Group#] = @Group) AND ([Period] = @Period) AND (Choice = @Choice);
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;
	INSERT INTO ErrorLog VALUES (GETDATE(),ERROR_NUMBER(), ERROR_MESSAGE(), 2);
	--PRINT  CAST(ERROR_NUMBER() AS VARCHAR) + ' Error in OFFER: ' + ERROR_MESSAGE();
	RETURN ERROR_NUMBER();
END CATCH

--****************************SELLER ******************************
BEGIN TRY
	UPDATE Shares SET BalanceConfirm = BalanceConfirm + @Vol * @Price, Volume = Volume - @Vol WHERE ([Owner] = @Seller) AND (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);

	DECLARE @MinB FLOAT;
	SELECT @MinB = CASE WHEN BalanceVoid > BalanceConfirm THEN BalanceConfirm ELSE BalanceVoid END
		FROM Shares
		WHERE ([Owner] = @Seller) AND (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);
				
	PRINT 'MinB = ' + CAST(@MinB AS VARCHAR);
	
	IF @MinB > 0
	BEGIN
		PRINT 'MinB > 0 ';

		UPDATE Shares
		SET BalanceConfirm = BalanceConfirm - @MinB , BalanceVoid = BalanceVoid - @MinB
		WHERE ([Owner] = @Seller) AND (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);	

		UPDATE People 
		SET Balance = Balance + @MinB
		WHERE ([ID] = @Seller)
	END;
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;
	INSERT INTO ErrorLog VALUES (GETDATE(),ERROR_NUMBER(), ERROR_MESSAGE(), 3);
	--PRINT CAST(ERROR_NUMBER() AS VARCHAR) + ' Shares Seller: ' + ERROR_MESSAGE();
	RETURN ERROR_NUMBER(); -- 547 : Seller does not have enough Shares.
END CATCH	

--*****************************BUYER********************************
	
BEGIN TRY
	DECLARE @Deficit FLOAT;
	SELECT @Deficit = @Vol * @Price - BalanceConfirm 
	FROM Shares 
	WHERE ([Owner] = @Buyer) AND (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);

	IF @Deficit IS NULL
	BEGIN
		INSERT INTO Shares VALUES (@Buyer, @Treatment, @Group, @Period, @Choice, @Vol, 0, @Vol * @Price);
		UPDATE People SET Balance = Balance - @Vol * @Price WHERE ID = @Buyer;
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
		UPDATE Shares SET BalanceConfirm = BalanceConfirm - @Vol * @Price, Volume = Volume + @Vol WHERE ([Owner] = @Buyer) AND (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);
	END
	ELSE
	BEGIN -- With Money Transfer From People.Balance
		--PRINT 'Deficit > 0';
		UPDATE People SET Balance = Balance - @Deficit WHERE ID = @Buyer; 
		UPDATE Shares SET BalanceConfirm = 0, BalanceVoid = BalanceVoid + @Deficit , Volume = Volume + @Vol 
			WHERE ([Owner] = @Buyer) AND (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);
	END;
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;
	INSERT INTO ErrorLog VALUES (GETDATE(),ERROR_NUMBER(), ERROR_MESSAGE(), 5);
	--PRINT CAST(ERROR_NUMBER() AS VARCHAR) + ' UPDATE Buyer: ' + ERROR_MESSAGE() ;
	RETURN ERROR_NUMBER(); -- 547 : Buyer does not have enough Balance
END CATCH;
COMMIT TRANSACTION;
--PRINT 'Completed';
RETURN 1;
END