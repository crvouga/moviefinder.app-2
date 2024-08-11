module [Route, encode, decode]
import Url exposing [Url]
import Feed.Form.Route

Route : [Feed, FeedItemsLoad { limit : U64, offset : U64 }, Form Feed.Form.Route.Route, ChangedSlide { index : U64 }, Unknown]

encode : Route -> Url
encode = \route ->
    when route is
        Feed ->
            "/feed" |> Url.fromStr

        FeedItemsLoad _ ->
            "/feed/feed-items-load"
            |> Url.fromStr

        ChangedSlide payload ->
            "/feed/changed-slide" |> Url.fromStr |> Url.appendParam "index" (Num.toStr payload.index)

        Form r ->
            Feed.Form.Route.encode r

        Unknown ->
            Url.fromStr "/"

decode : Url -> Route
decode = \url ->
    when Url.path url is
        "/feed" ->
            Feed

        "/feed/feed-items-load" ->
            queryParams = Url.queryParams url
            limitStr = queryParams |> Dict.get "limit" |> Result.withDefault ""
            offsetStr = queryParams |> Dict.get "offset" |> Result.withDefault ""
            limit = limitStr |> Str.toU64 |> Result.withDefault 10
            offset = offsetStr |> Str.toU64 |> Result.withDefault 0
            FeedItemsLoad { limit, offset }

        "/feed/changed-slide" ->
            queryParams = Url.queryParams url
            index = queryParams |> Dict.get "index" |> Result.try Str.toU64 |> Result.withDefault 0
            ChangedSlide { index }

        _ ->
            Unknown
