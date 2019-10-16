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

	--************************************************
	BEGIN TRY
		INSERT INTO Transactions VALUES (@Treatment, @Group, @Period, @Choice, @Seller, @Sell_Time, @Buyer, @Buy_Time, @Price, @Vol);	
	END TRY
	BEGIN CATCH
	ROLLBACK TRANSACTION;
		PRINT 'Transaction: ' + CAST(ERROR_NUMBER() AS VARCHAR);
		RETURN ERROR_NUMBER();
	END CATCH
	   
	--************************************************************************************************

	--****************************SELLER ******************************
	BEGIN TRY
			UPDATE Shares SET BalanceConfirm = BalanceConfirm + @Vol * @Price, Volume = Volume - @Vol WHERE ([Owner] = @Seller) AND (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);
-- Shares.Seller.Volume < 0 --> Error
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		PRINT 'Shares Seller: ' + CAST(ERROR_NUMBER() AS VARCHAR);
		RETURN ERROR_NUMBER();
	END CATCH

	DECLARE @MinB AS FLOAT;

	SET @MinB = (
		SELECT CASE WHEN BalanceVoid > BalanceConfirm THEN BalanceConfirm ELSE BalanceVoid END
		FROM Shares
		WHERE ([Owner] = @Seller) AND (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice)
	);

	
	IF @MinB>0 
	BEGIN
		UPDATE Shares
		SET BalanceConfirm = BalanceConfirm - @MinB , BalanceVoid = BalanceVoid - @MinB
		WHERE ([Owner] = @Seller) AND (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);	

		UPDATE People 
		SET Balance = Balance + @MinB
		WHERE ([ID] = @Seller)
	END;
	

	--*****************************BUYER********************************

	
    BEGIN TRY 
		INSERT INTO Shares VALUES (@Buyer, @Treatment, @Group, @Period, @Choice, @Vol, 0, @Vol * @Price);

		UPDATE People SET Balance = Balance - @Vol * @Price WHERE ID = @Buyer;

	END TRY
	BEGIN CATCH
		IF ERROR_NUMBER() = 2627		
		BEGIN TRY

			DECLARE @Deficit AS FLOAT;

			SET @Deficit = @Vol * @Price - (
				SELECT BalanceConfirm 
				FROM Shares 
				WHERE ([Owner] = @Buyer) AND (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice)
			);

			IF @Deficit >= 0
			BEGIN -- No Money Transfer
				UPDATE Shares SET BalanceConfirm = BalanceConfirm - @Vol * @Price, Volume = Volume + @Vol WHERE ([Owner] = @Buyer) AND (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);
			END
			ELSE
			BEGIN -- Money Transfer 

			UPDATE Shares SET BalanceConfirm = 0, BalanceVoid = BalanceVoid + @Deficit , Volume = Volume + @Vol WHERE ([Owner] = @Buyer) AND (Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice);
			UPDATE People SET Balance = Balance - @Deficit WHERE ID = @Buyer; 
-- People.Buyer.Balance < 0 --> Error

			END;

		END TRY
		BEGIN CATCH

			

			ROLLBACK TRANSACTION;
			PRINT 'UPDATE Shares | Buyer: ' + CAST(ERROR_NUMBER() AS VARCHAR);
			RETURN ERROR_NUMBER();
		END CATCH						
		ELSE
		BEGIN
			ROLLBACK TRANSACTION;
			PRINT 'INSERT Shares / UPDATE People | Buyer: ' + CAST(ERROR_NUMBER() AS VARCHAR);
			RETURN ERROR_NUMBER();
		END;
	END CATCH

COMMIT TRANSACTION
PRINT 1;
RETURN 1;
END