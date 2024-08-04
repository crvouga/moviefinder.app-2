module [Route, encode, decode]

import Url exposing [Url]

Route : [Account]

encode : Route -> Url
encode = \route ->
    when route is
        Account -> Url.fromStr "/account"

decode : Url -> Route
decode = \url ->
    when Url.path url is
        "/account" -> Account
        _ -> Account
