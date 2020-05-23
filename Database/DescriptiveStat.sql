--SELECT Treatment, Count(*) AS Participants, AVG(People.EnglishSpeaker*1.0) AS English, SUM(Balance-10)TotalBonus, AVG(Balance-10) as AVGBonus,
--AVG(Score1*1.0)as S1,AVG(Score2*1.0) as s2,AVG(Score3*1.0)as s4,AVG(Score4*1.0)as s3 
--FROM People 
--WHERE Completed IS NOT NULL AND Treatment >=13
--Group By Treatment


--SELECT [ID], [Age] ,[Gender] ,[EnglishSpeaker], 
--DATEDIFF(SECOND, '18:00:00', FORMAT([CreationTime],'HH:mm:ss')) AS Create_Seconds_After_6PM, 
--DATEDIFF(SECOND, '18:00:00', FORMAT([QualificationTime],'HH:mm:ss')) AS Qual_Seconds_After_6PM,
--[Balance]-10 AS Bonus,
--[Score1] ,[Score2] ,[Score3] ,[Score4], 
--[Treatment]
--FROM [dbo].[People] 
--WHERE [Treatment] > = 13 AND [Completed] > 'June 2018' 
--ORDER BY Treatment

SELECT Treatment,Gender, Count(*) AS CF, AVG(Balance-10)
 FROM [dbo].[People] 
 WHERE [Treatment] > = 13 AND [Completed] IS NOT NULL

 Group BY Gender, Treatment

--SELECT CASE WHEN Age<17 THEN 0 WHEN Age <40 THEN 1 ELSE 2 END, AVG(Balance-10), Count(*)
-- FROM [dbo].[People] 
-- WHERE [Treatment] > = 13 AND [Completed] > 'June 2018' 
-- Group BY CASE WHEN Age<17 THEN 0 WHEN Age <40 THEN 1 ELSE 2 END

--SELECT AA.Treatment, AA.Period/2 AS Round, m, AVG(VotePerPerson*1.0) AS AVGVOTE
--FROM
--(SELECT Treatment, Period, Voter, count(*) AS VotePerPerson
--FROM Voting
--GROUP BY Treatment, Period, Voter) AS AA
--LEFT JOIN(
--SELECT Treatment, Period, Count(*) as m
--FROM Versions
--GROUP BY Treatment, Period) AS BB
--ON AA.Treatment = BB.Treatment AND AA.Period = BB.Period
--WHERE AA.Treatment >= 13
--GROUP BY AA.Treatment, AA.Period, m

--SELECT Treatment, Period, Count(*) as m
--FROM Versions
--GROUP BY Treatment, Period
--ORDER BY Treatment DESC, Period DESC

--SELECT Treatment, Period/2 AS Round, sum(VotePerPerson) AS SumVotes
--FROM ( SELECT Treatment, Period, Voter, count(*)*1.0 AS VotePerPerson
--FROM Voting
--WHERE Treatment >= 13
--GROUP BY Treatment, Period, Voter) AS VotePerson
--GROUP BY Treatment, Period
--ORDER BY Treatment, Period 
