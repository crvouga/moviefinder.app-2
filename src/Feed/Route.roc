module [Route, encode, decode]
import Url exposing [Url]
import Feed.Controls.Route

Route : [
    Feed,
    LoadNext,
    LoadPrev,
    Controls Feed.Controls.Route.Route,
    ChangedSlide { index : U64 },
    Unknown,
]

encode : Route -> Url
encode = \route ->
    when route is
        Feed ->
            "/feed" |> Url.fromStr

        LoadNext ->
            "/feed/load-next" |> Url.fromStr

        LoadPrev ->
            "/feed/load-prev" |> Url.fromStr

        ChangedSlide payload ->
            "/feed/changed-slide" |> Url.fromStr |> Url.appendParam "index" (Num.toStr payload.index)

        Controls r ->
            Feed.Controls.Route.encode r

        Unknown ->
            Url.fromStr "/"

decode : Url -> Route
decode = \url ->
    when Url.path url is
        "/feed" ->
            Feed

        "/feed/load-next" ->
            LoadNext

        "/feed/load-prev" ->
            LoadPrev

        "/feed/changed-slide" ->
            queryParams = Url.queryParams url
            index = queryParams |> Dict.get "index" |> Result.try Str.toU64 |> Result.withDefault 0
            ChangedSlide { index }

        _ ->
            Unknown
