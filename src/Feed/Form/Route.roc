module [Route, encode, decode]
import Url exposing [Url]

Route : [Form, FormLoad, Unknown]

encode : Route -> Url
encode = \route ->
    when route is
        Form -> "/feed-form" |> Url.fromStr
        FormLoad -> "/feed-form/load" |> Url.fromStr
        Unknown -> Url.fromStr "/"

decode : Url -> Route
decode = \url ->
    when Url.path url is
        "/feed-form" -> Form
        "/feed-form/load" -> FormLoad
        _ -> Unknown

