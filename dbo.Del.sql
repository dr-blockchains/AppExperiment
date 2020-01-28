CREATE PROCEDURE [dbo].[Del]
	@Treatment INT, 
	@Group INT,
	@Period INT,
	@Choice INT
AS
BEGIN TRANSACTION;
BEGIN TRY	
	DELETE FROM Shares WHERE Treatment = @Treatment AND Group# = @Group AND Period = @Period AND Choice >= @Choice;
	DELETE FROM Versions WHERE Treatment = @Treatment AND Group# = @Group AND Period = @Period AND Choice = @Choice;
	UPDATE Versions SET Choice = Choice - 1 WHERE Treatment = @Treatment AND Group# = @Group AND Period = @Period AND Choice > @Choice;
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;
	INSERT INTO ErrorLog VALUES (GETDATE(),ERROR_NUMBER(), ERROR_MESSAGE(), 50);
	--PRINT  CAST(ERROR_NUMBER() AS VARCHAR) + ' Error in deleting version: ' + ERROR_MESSAGE();
	RETURN ERROR_NUMBER();
END CATCH;
COMMIT TRANSACTION;
PRINT 'Completed Deleting';
RETURN 1;