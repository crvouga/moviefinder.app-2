module [
    html,
    redirect,
    text,
    Response,
    toHttp,
]

import pf.Http
import Html
import Route
import Url

Response : [
    Html Html.Node,
    Text Str,
    Redirect Route.Route,
]

html : Html.Node -> Response
html = Html

text : Str -> Response
text = Text

redirect : Route.Route -> Response
redirect = \route -> Redirect route

httpHeader : Str, Str -> Http.Header
httpHeader = \name, value -> {
    name,
    value: Str.toUtf8 value,
    # value,
}

toHttp : Response -> Http.Response
toHttp = \res ->
    when res is
        Html node ->
            {
                status: 200,
                headers: [
                    httpHeader "Content-Type" "text/html; charset=utf-8",
                ],
                body: node |> Html.render |> Str.toUtf8,
            }

        Text body ->
            {
                status: 200,
                headers: [
                    httpHeader "Content-Type" "text/plain; charset=utf-8",
                ],
                body: Str.toUtf8 body,
            }

        Redirect route ->
            url = Route.encode route
            {
                status: 302,
                headers: [
                    httpHeader "Location" (Url.toStr url),
                    httpHeader "Hx-Push-Url" (Url.toStr url),
                ],
                body: Str.toUtf8 "",
            }
