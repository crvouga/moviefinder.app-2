module [Route, encode, decode]

Route : [Feed, FeedItems]

encode : Route -> Str
encode = \route ->
    when route is
        Feed -> "/feed"
        FeedItems -> "/feed/feed-items"

decode : Str -> Route
decode = \str ->
    when str is
        "/feed" -> Feed
        "/feed/feed-items" -> FeedItems
        _ -> Feed
