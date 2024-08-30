module [Route, encode, decode]
import Url exposing [Url]
import Feed.Controls.Item exposing [Item]

Route : [Controls, ControlsLoad, Unknown, ClickedChip Item]

encode : Route -> Url
encode = \route ->
    when route is
        Controls -> "/feed/controls" |> Url.fromStr
        ControlsLoad -> "/feed/controls/load" |> Url.fromStr
        ClickedChip item ->
            "/feed/controls/clicked-chip"
            |> Url.fromStr
            |> Url.appendParam "item" (Item.toUrlSafeStr item)
        Unknown -> Url.fromStr "/"

decode : Url -> Route
decode = \url ->
    when Url.toPaths url is
        ["/feed", "/controls"] -> Controls
        ["/feed", "/controls", "/load"] -> ControlsLoad
        _ -> Unknown

