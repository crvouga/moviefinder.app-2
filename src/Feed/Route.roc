module [Route, encode, decode]

Route : [Feed]

encode : Route -> Str
encode = \route ->
    when route is
        Feed -> "/feed"

decode : Str -> Route
decode = \str ->
    when str is
        "/feed" -> Feed
        _ -> Feed
