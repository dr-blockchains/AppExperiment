CREATE TABLE [dbo].[Orders] (
    [Treatment]    INT            NOT NULL,
    [Group#]       INT            NOT NULL,
    [Period]       INT            NOT NULL,
    [Choice]       INT            NOT NULL,
    [Bidder]       NVARCHAR (100) NOT NULL,
    [Time]         DATETIME       NOT NULL,
    [DShare]       REAL           CONSTRAINT [DF_Orders_Volume] DEFAULT ((0)) NOT NULL,
    [UnFullfilled] REAL           CONSTRAINT [DF_Orders_Fullfilled] DEFAULT ((0)) NULL,

	[Price1]        REAL           NOT NULL,
	[Price2]        REAL           NOT NULL,
    
	CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED ([Treatment] DESC, [Group#] DESC, [Period] DESC, [Choice] ASC, [Bidder] ASC, [Time] DESC),
    CONSTRAINT [FK_Orders_People] FOREIGN KEY ([Bidder]) REFERENCES [dbo].[People] ([ID]),
    CONSTRAINT [FK_Orders_Versions] FOREIGN KEY ([Treatment], [Group#], [Period], [Choice]) REFERENCES [dbo].[Versions] ([Treatment], [Group#], [Period], [Choice]),
    CONSTRAINT [NonNegative] CHECK ([UnFullfilled]>=(0)),

    CONSTRAINT [NonZero] CHECK ([DShare]!=(0)),
	CONSTRAINT [StartPrice] CHECK ([Price1]>=(0)),
	CONSTRAINT [EndingPrice] CHECK ([Price2]>=(0)),
);