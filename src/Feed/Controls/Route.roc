module [Route, encode, decode]
import Url exposing [Url]
import Feed.Controls.Item as Item exposing [Item]
import Feed.FeedId as FeedId exposing [FeedId]

Route : [Controls { feedId : FeedId }, ControlsLoad, Unknown, ClickedChip Item]

encode : Route -> Url
encode = \route ->
    when route is
        Controls { feedId } -> "/feed/controls" |> Url.fromStr |> Url.appendParam "feedId" (FeedId.toStr feedId)
        ControlsLoad -> "/feed/controls/load" |> Url.fromStr
        ClickedChip item ->
            "/feed/controls/clicked-chip"
            |> Url.fromStr
            |> Url.appendParam "item" (Item.encode item)

        Unknown -> Url.fromStr "/"

decode : Url -> Route
decode = \url ->
    when Url.toPaths url is
        ["/feed", "/controls"] ->
            feedId = url |> Url.queryParams |> Dict.get "feedId" |> Result.withDefault "" |> FeedId.fromStr
            Controls { feedId }

        ["/feed", "/controls", "/load"] -> ControlsLoad
        _ -> Unknown

