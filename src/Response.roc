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

toHttp : Response -> Http.Response
toHttp = \res ->
    when res is
        Html node ->
            {
                status: 200,
                headers: [
                    { name: "Content-Type", value: Str.toUtf8 "text/html; charset=utf-8" },
                ],
                body: node |> Html.render |> Str.toUtf8,
            }

        Text body ->
            {
                status: 200,
                headers: [
                    { name: "Content-Type", value: Str.toUtf8 "text/plain; charset=utf-8" },
                ],
                body: Str.toUtf8 body,
            }

        Redirect route ->
            url = Route.encode route
            {
                status: 302,
                headers: [
                    { name: "Location", value: Str.toUtf8 url },
                    { name: "Hx-Push-Url", value: Str.toUtf8 url },
                ],
                body: Str.toUtf8 "",
            }
