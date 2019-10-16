SELECT
	Versions.Proposer,
	Versions.Artifact,	
	Versions.Choice,
	CASE WHEN VotesOnChoices.votes IS NULL THEN 0 ELSE VotesOnChoices.votes END AS votes,
	CASE WHEN VotesOnChoices.Choice <> 0
	THEN
		CASE WHEN EXISTS (
			SELECT VoteWeight
			FROM Voting CurrentVoteCheck
			WHERE CurrentVoteCheck.Choice = 0 AND CurrentVoteCheck.Period = VotesOnChoices.Period AND CurrentVoteCheck.Treatment = VotesOnChoices.Treatment
		)
		THEN VotesOnChoices.votes - (
			SELECT SUM(VotingTemp.VoteWeight) AS votes
			FROM Voting VotingTemp
			WHERE VotingTemp.choice = 0 AND VotingTemp.Period = VotesOnChoices.Period AND VotingTemp.Treatment = VotesOnChoices.Treatment
		)
		ELSE VotesOnChoices.votes
		END
	ELSE 0
	END AS VotesDiffFromCurrent

FROM (
	SELECT
		treatment,
		period,
		choice,
		SUM(VoteWeight) AS votes
	FROM Voting
	GROUP BY treatment, period, choice) 
	AS VotesOnChoices FULL JOIN Versions 
					ON Versions.Treatment = VotesOnChoices.Treatment 
					AND Versions.Period = VotesOnChoices.Period 
					AND Versions.Treatment = VotesOnChoices.Treatment

WHERE Versions.Treatment = 15 and Versions.Period=18