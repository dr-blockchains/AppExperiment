CREATE PROCEDURE [dbo].[Orient]
( 
	@Treatment INT, 
	@Group INT,
	@User NVARCHAR(50),
	@Vol REAL
)
AS
BEGIN TRANSACTION
BEGIN TRY		
	--DECLARE @CurrentTime DATETIME = GETDATE();
	--DECLARE @Score REAL;

	--SELECT @Score = Score 
	--		FROM Versions 
	--		WHERE Treatment = @Treatment AND [Group#] = @Group AND [Period] = @Period AND Choice = 0;

	--INSERT INTO Offers VALUES (@Treatment, @Group, @Period, 0, 'Experimenter', @CurrentTime, @Score, 0, 0, 0);	 

	--INSERT INTO Transactions VALUES (@Treatment, @Group, @Period, 0, 'Experimenter', @CurrentTime, 'Experimenter', @CurrentTime, @Score, 0);

	--UPDATE Versions SET Score = @Score WHERE Treatment = @Treatment AND Group# = @Group AND [Period] = @Period;
				
	DECLARE @m INT;
	SELECT @m = COUNT(Choice) 	
	FROM Versions 
	WHERE Treatment = @Treatment AND [Group#] = @Group AND [Period] = 2;
	
	DECLARE @i INT = 0;
	WHILE @i < @m
	BEGIN
		INSERT INTO Shares
		VALUES (@User, @Treatment, @Group, 2, @i, @Vol, 0, 0);

		SET @i = @i + 1 ;
	END;

END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;
	INSERT INTO ErrorLog VALUES (GETDATE(),ERROR_NUMBER(), ERROR_MESSAGE(), 40);
	--PRINT  CAST(ERROR_NUMBER() AS VARCHAR) + ' Error in StartTrading: ' + ERROR_MESSAGE();
	RETURN ERROR_NUMBER();
END CATCH;	
COMMIT TRANSACTION;
PRINT 'Completed';
RETURN 1;