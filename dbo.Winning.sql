CREATE PROCEDURE [dbo].[Winning]
( 
	@Treatment INT, 
	@Group INT,
	@Period INT, 
	@Winner INT	
)
AS
BEGIN	
BEGIN TRANSACTION
BEGIN TRY
	UPDATE People SET Balance = Balance 
								+ (SELECT COALESCE(BalanceConfirm, 0) FROM Shares WHERE [Owner] = People.ID AND Choice = @Winner AND [Period] = @Period)
								+ (SELECT COALESCE(SUM(BalanceVoid),0) FROM Shares WHERE [Owner] = People.ID AND Choice != @Winner AND [Period] = @Period)
	WHERE Treatment = @Treatment AND [Group#] = @Group;
	
	DECLARE @Score FLOAT, @Fund FLOAT;

	SELECT @Score = Score, @Fund = Fund FROM Versions 
		WHERE Treatment = @Treatment AND [Group#] = @Group AND [Period] = @Period AND Choice = @Winner;

	UPDATE Versions SET Score = @Score, Fund = @Fund
		WHERE Treatment = @Treatment AND [Group#] = @Group AND [Period] = @Period + 2;

    DECLARE @m INT;
	SELECT @m = COUNT(Choice)	FROM Versions 
		WHERE Treatment = @Treatment AND [Group#] = @Group AND [Period] = @Period + 2;
	
	DECLARE @i INT = 0;
	WHILE @i < @m
	BEGIN
		INSERT INTO Shares
			SELECT Owner , Treatment , Group# , [Period] + 2 , @i , Volume , 0 , 0
            FROM Shares
            WHERE Treatment = @Treatment AND [Group#] = @Group AND [Period] = @Period AND Choice = @Winner;

		SET @i = @i + 1;
	END;

	--INSERT INTO Offers SELECT  Treatment, Group#, @Period + 2 , 0, Bidder, [Time] , Price, UnFullfilled, UnFullfilled, Buy0Sell1
    --                      FROM Offers
    --                      WHERE Treatment = @Treatment AND [Group#] = @Group AND [Period] = @Period AND Choice = @Winner AND UnFullfilled>0;

END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;
	INSERT INTO ErrorLog VALUES (GETDATE(),ERROR_NUMBER(), ERROR_MESSAGE(), 10);
	--PRINT  CAST(ERROR_NUMBER() AS VARCHAR) + ' Error in Winning: ' + ERROR_MESSAGE();
	RETURN ERROR_NUMBER();
END CATCH;	
COMMIT TRANSACTION;
PRINT 'Completed';
RETURN 1;
END