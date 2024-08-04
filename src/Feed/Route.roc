module [Route, encode, decode]
import Url exposing [Url]

Route : [Feed, FeedItems { limit : U64, offset : U64 }]

encode : Route -> Url
encode = \route ->
    when route is
        Feed -> "/feed" |> Url.fromStr
        FeedItems mediaQuery ->
            "/feed/feed-items"
            |> Url.fromStr
            |> Url.appendParam "limit" (Num.toStr mediaQuery.limit)
            |> Url.appendParam "offset" (Num.toStr mediaQuery.offset)

decode : Url -> Route
decode = \url ->
    when Url.path url is
        "/feed" -> Feed
        "/feed/feed-items" ->
            queryParams = Url.queryParams url
            limitStr = queryParams |> Dict.get "limit" |> Result.withDefault ""
            offsetStr = queryParams |> Dict.get "offset" |> Result.withDefault ""
            limit = limitStr |> Str.toU64 |> Result.withDefault 10
            offset = offsetStr |> Str.toU64 |> Result.withDefault 0
            FeedItems { limit, offset }

        _ -> Feed

