module [MediaType, fromStr, toStr]

MediaType : [Movie, Tv]

fromStr : Str -> MediaType
fromStr = \str ->
    when str is
        "movie" -> Movie
        "tv" -> Tv
        _ -> Movie

toStr : MediaType -> Str
toStr = \mediaType ->
    when mediaType is
        Movie -> "movie"
        Tv -> "tv"
