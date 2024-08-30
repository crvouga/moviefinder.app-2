module [MediaId, fromStr, toStr]

MediaId : Str

fromStr : Str -> MediaId
fromStr = \str -> str

toStr : MediaId -> Str
toStr = \mediaId -> mediaId
