--SELECT min(Votez) AS SumVoteZ from (  --) AS TTT

SELECT 	
	Versions.Period,
	Versions.Choice, 
	CASE WHEN SumVotes IS NUll THEN 0 ELSE SumVotes END AS SumVoteZ,	
	Versions.Proposer,
	Versions.Artifact,
	Versions.Time
FROM (SELECT treatment, period, choice, sum(VoteWeight) AS SumVotes 
		FROM Voting 
		GROUP BY treatment, period, choice) AS VotesOnChoices RIGHT JOIN Versions
ON Versions.Treatment = VotesOnChoices.Treatment AND Versions.Period = VotesOnChoices.Period AND VotesOnChoices.Choice = Versions.Choice
WHERE Versions.Treatment = 0
ORDER BY Versions.Period DESC, SumVoteZ DESC, Choice ASC 

select * from Treatments


