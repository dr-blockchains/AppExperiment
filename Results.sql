SELECT [Balance]-10 AS Bonus,
       People.Treatment,
       [Age] ,[Gender] ,[EnglishSpeaker], 	  
	   [Score1] ,[Score2] ,[Score3] ,[Score4], 
	   
	   CASE WHEN SUM(VersionVotes.Votes) IS NULL THEN 0 ELSE SUM(VersionVotes.Votes) END AS VoteInstancesReceived,
       CASE WHEN SUM(VersionVotes.Won) IS NULL THEN 0 ELSE SUM(VersionVotes.Won) END AS SuggestionWins,
       CASE WHEN SUM(VersionVotes.New) IS NULL THEN 0 ELSE SUM(VersionVotes.New) END AS SuggestionsMade,
	   DATEDIFF(SECOND, '18:00:00', FORMAT([CreationTime],'HH:mm:ss')) AS Create_Seconds_After_6PM, 
	   DATEDIFF(SECOND, '18:00:00', FORMAT([QualificationTime],'HH:mm:ss')) AS Qual_Seconds_After_6PM,
	   People.ID, 
	   [Education]
FROM People
LEFT JOIN (
       SELECT
              c.Treatment,
              c.Group#,
              c.Period,
              c.Choice,
              SUM(v.VoteWeight) AS Weight,
              COUNT(v.Choice) AS Votes,
              CASE WHEN c.Choice = 0 THEN 1 ELSE 0 END AS Won,
              CASE WHEN c.Choice = 0 THEN 0 ELSE 1 END AS New,
              c.Proposer
       FROM Versions c
       LEFT JOIN Voting v ON (
              c.Treatment = v.Treatment
              AND c.Group# = v.Group#
              AND c.Period = v.Period
              AND c.Choice = v.Choice
       )
       GROUP BY
              c.Treatment,
              c.Group#,
              c.Period,
              c.Choice,
              c.Proposer
) VersionVotes ON VersionVotes.Proposer = People.ID
WHERE People.Treatment>=13 AND People.Completed IS NOT NULL
GROUP BY
People.Treatment,
       People.ID,       
       [CreationTime],
	   [QualificationTime],	   
       [Education],
       [Age],
       [EnglishSpeaker],
       [Balance],
       Gender,
       [Score1],
       [Score2],
       [Score3],
       [Score4]       

ORDER BY Treatment, Age

--SELECT TOP 1000 [ID] ,[Name] ,[CreationTime] ,[Education] ,[Age] ,[Gender] ,[EnglishSpeaker] ,[Treatment] ,[Group#] ,[QualificationTime] ,[Balance] ,[Completed] 
--FROM [dbo].[People] 
--WHERE [Treatment] = 6 AND QualificationTime IS NOT NULL
--ORDER BY [CreationTime]

--SELECT  [ID], Name, [Balance] , Treatment, Response1 
--FROM [dbo].[People] 
--WHERE [CreationTime] > '6/5/2018 7 PM' 
----AND [Treatment] = 9 AND [Group#] = 1 
----AND [QualificationTime] IS NULL
----AND Completed IS NOT NULL
----ORDER BY [CreationTime] DESC

--SELECT Versions.Period/2 AS Round, CASE WHEN Versions.Choice = 0 THEN -9999999999999 ELSE Versions.Choice END AS Choice, Versions.Proposer, 
--				CASE WHEN SumVotes IS NULL THEN 0 ELSE SumVotes END AS SumVoteZ,
--				Versions.Artifact					
--                FROM(SELECT treatment, Group#, period, choice, sum(VoteWeight) AS SumVotes
--                        FROM Voting
--                        GROUP BY treatment, Group#, period, choice) AS VotesOnChoices RIGHT JOIN Versions ON 
--                                                        Versions.Treatment = VotesOnChoices.Treatment AND 
--                                                        Versions.Group# = VotesOnChoices.Group# AND 
--                                                        Versions.Period = VotesOnChoices.Period AND 
--                                                        VotesOnChoices.Choice = Versions.Choice 
--                WHERE Versions.Treatment= 9 AND Versions.Group#= 1 -- AND Versions.Period = 14
--                ORDER BY Round DESC, Versions.Choice ASC


--SELECT  '<span class="version-choice">' + 
--CASE WHEN Versions.Choice = 0 THEN '<hr><h3>Versions in Round ' + CAST(Versions.Period/2 AS VARCHAR(MAX)) + ':</h3>'+ (CASE WHEN Versions.Proposer = 'Experimenter' THEN 'Initial Edition' ELSE 'Updated Edition' END) 
--ELSE '&nbsp; &gt; &nbsp;Suggestion ' + CAST(Versions.Choice AS VARCHAR(MAX)) END +
-- ' ('+ Versions.Proposer + '): Voted = '+CAST((CASE WHEN SumVotes IS NULL THEN 0 ELSE SumVotes END) AS VARCHAR(MAX))+'</span><div class="version-artifact"><br>' + REPLACE(Versions.HtmlArtifact, CHAR(13), '<br>') + '</div><br>' 
--AS Content, 
--Versions.Choice 					

--FROM   (SELECT treatment, Group#, period, choice, sum(VoteWeight) AS SumVotes
--        FROM Voting
--        GROUP BY treatment, Group#, period, choice) AS VotesOnChoices 
--RIGHT JOIN Versions ON
--		           Versions.Treatment = VotesOnChoices.Treatment AND 
--				   Versions.Group# = VotesOnChoices.Group# AND 
--				   Versions.Period = VotesOnChoices.Period AND 
--				   VotesOnChoices.Choice = Versions.Choice 
--WHERE Versions.Treatment= 9 AND Versions.Group#= 1
--ORDER BY Versions.Period DESC, Versions.Choice ASC

