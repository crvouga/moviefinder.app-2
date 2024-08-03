module [Route, encode, decode]

Route : [Feed, FeedItems]

encode : Route -> Str
encode = \route ->
    when route is
        Feed -> "/feed"
        FeedItems -> "/feed/items"

decode : Str -> Route
decode = \str ->
    when str is
        "/feed" -> Feed
        "/feed/items" -> FeedItems
        _ -> Feed
