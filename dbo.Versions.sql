CREATE TABLE [dbo].[Versions] (
    [Treatment]    INT            NOT NULL,
    [Group#]       INT            DEFAULT ((1)) NOT NULL,
    [Period]       INT            NOT NULL,
    [Choice]       INT            NOT NULL,
    [Artifact]     NVARCHAR (MAX) NOT NULL,
    [HtmlArtifact] NVARCHAR (MAX) NULL,
    [Proposer]     NVARCHAR (100) NOT NULL,
    [Time]         DATETIME       NOT NULL,
    [Score]        REAL           DEFAULT ((0)) NOT NULL,
    [PerVal]       REAL           DEFAULT ((1)) NULL,
	[Fund]         REAL           DEFAULT ((0)) NULL,
    PRIMARY KEY CLUSTERED ([Treatment] ASC, [Group#] ASC, [Period] ASC, [Choice] ASC),
    CONSTRAINT [Proposer_User] FOREIGN KEY ([Proposer]) REFERENCES [dbo].[People] ([ID]),
    CONSTRAINT [FK_Versions_Groups] FOREIGN KEY ([Treatment], [Group#]) REFERENCES [dbo].[Groups] ([Treatment], [Group#]),
    CONSTRAINT [Score] CHECK ([Score]>=(0))
);