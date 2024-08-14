module [Route, encode, decode]
import Url exposing [Url]

Route : [Controls, ControlsLoad, Unknown]

encode : Route -> Url
encode = \route ->
    when route is
        Controls -> "/feed/controls" |> Url.fromStr
        ControlsLoad -> "/feed/controls/load" |> Url.fromStr
        Unknown -> Url.fromStr "/"

decode : Url -> Route
decode = \url ->
    when Url.path url is
        "/feed/controls" -> Controls
        "/feed/controls/load" -> ControlsLoad
        _ -> Unknown

