module [
    html,
    redirect,
    text,
    Response,
    toHttp,
    hxTrigger,
]

import pf.Http
import Html
import Route
import Url

ResponseVariant : [
    Html Html.Node,
    Text Str,
    Redirect Route.Route,
]

HxTrigger : [Just Str, Missing]

Response : {
    variant : ResponseVariant,
    hxTrigger : HxTrigger,
}

hxTrigger : Response, Str -> Response
hxTrigger = \res, trigger -> { res & hxTrigger: Just trigger }

html : Html.Node -> Response
html = \node -> { variant: Html node, hxTrigger: Missing }

text : Str -> Response
text = \str -> { variant: Text str, hxTrigger: Missing }

redirect : Route.Route -> Response
redirect = \route -> { variant: Redirect route, hxTrigger: Missing }

httpHeader : Str, Str -> Http.Header
httpHeader = \name, value -> {
    name,
    value: Str.toUtf8 value,
    # value,
}

appendHxTrigger : List Http.Header, HxTrigger -> List Http.Header
appendHxTrigger = \headers, trigger ->
    when trigger is
        Just hxTriggerValue ->
            List.append headers (httpHeader "Hx-Trigger" hxTriggerValue)

        Missing ->
            headers

toHttp : Response -> Http.Response
toHttp = \res ->
    when res.variant is
        Html node ->
            {
                status: 200,
                headers: [
                    httpHeader "Content-Type" "text/html; charset=utf-8",
                ]
                |> appendHxTrigger res.hxTrigger,
                body: node |> Html.render |> Str.toUtf8,
            }

        Text body ->
            {
                status: 200,
                headers: [
                    httpHeader "Content-Type" "text/plain; charset=utf-8",

                ]
                |> appendHxTrigger res.hxTrigger,
                body: Str.toUtf8 body,
            }

        Redirect route ->
            url = Route.encode route
            {
                status: 302,
                headers: [
                    httpHeader "Location" (Url.toStr url),
                    httpHeader "Hx-Push-Url" (Url.toStr url),
                ]
                |> appendHxTrigger res.hxTrigger,
                body: Str.toUtf8 "",
            }
