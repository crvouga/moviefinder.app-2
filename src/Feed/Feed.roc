module [Feed, encode, decode, init]

import Feed.FeedId exposing [FeedId]
import Json
import Media.Genre exposing [Genre]

Feed : {
    feedId : FeedId,
    activeIndex : U64,
    genres : List Genre,
}

init : FeedId -> Feed
init = \feedId -> {
    feedId,
    activeIndex: 0,
    genres: [],
}

encode : Feed -> Str
encode = \feed ->
    feed |> Json.encode |> Str.fromUtf8 |> Result.withDefault ""

decode : Str -> Result Feed [Failed]
decode = \encoded ->
    encoded |> Str.toUtf8 |> Json.decode |> Result.mapErr (\_ -> Failed)
