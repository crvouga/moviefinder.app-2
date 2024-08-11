module [FeedId, fromStr, toStr]

FeedId : Str

fromStr : Str -> FeedId
fromStr = \str -> str

toStr : FeedId -> Str
toStr = \feedId -> feedId
