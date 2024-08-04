module [Route, encode, decode]

import Media.MediaDb as MediaDb

Route : [Feed, FeedItems MediaDb.MediaQuery]

encode : Route -> Str
encode = \route ->
    when route is
        Feed -> "/feed"
        FeedItems _ -> "/feed/feed-items"

decode : Str -> Route
decode = \str ->
    when str is
        "/feed" -> Feed
        "/feed/feed-items" -> FeedItems { limit: 10, offset: 0, orderBy: Asc MediaId, where: And [] }
        _ -> Feed


        