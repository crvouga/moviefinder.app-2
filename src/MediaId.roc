module [MediaId, fromStr, toStr]

MediaId := Str

fromStr : Str -> MediaId
fromStr = \str -> @MediaId str

toStr : MediaId -> Str
toStr = \@MediaId mediaId -> mediaId
