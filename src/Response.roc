module [
    html,
    redirect,
    text,
    nothing,
    Response,
    setCookie,
    toHttp,
    hxTrigger,
    staticHtml,
]

import pf.Http
import Html
import Route
import Url

ResponseVariant : [
    Html Html.Node,
    StaticHtml Html.Node,
    Text Str,
    Redirect Route.Route,
    Nothing,
]

HxTrigger : [Just Str, Missing]

Response : {
    variant : ResponseVariant,
    hxTrigger : HxTrigger,
    cookies : List { key : Str, value : Str },
}

hxTrigger : Response, Str -> Response
hxTrigger = \res, trigger -> { res & hxTrigger: Just trigger }

html : Html.Node -> Response
html = \node -> { variant: Html node, hxTrigger: Missing, cookies: [] }

staticHtml : Html.Node -> Response
staticHtml = \node -> { variant: StaticHtml node, hxTrigger: Missing, cookies: [] }

text : Str -> Response
text = \str -> { variant: Text str, hxTrigger: Missing, cookies: [] }

redirect : Route.Route -> Response
redirect = \route -> { variant: Redirect route, hxTrigger: Missing, cookies: [] }

nothing : Response
nothing = { variant: Nothing, hxTrigger: Missing, cookies: [] }

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

setCookie : Response, Str, Str -> Response
setCookie = \res, name, value -> { res & cookies: List.append res.cookies { key: name, value } }

appendSetCookie : List Http.Header, List { key : Str, value : Str } -> List Http.Header
appendSetCookie = \headers, cookies ->
    cookies
    |> List.map \{ key, value } -> httpHeader "Set-Cookie" ("$(key)=$(value); Path=/; HttpOnly; SameSite=Lax; Max-Age=31536000;")
    |> List.concat headers

toHttp : Response -> Http.Response
toHttp = \res ->
    when res.variant is
        Nothing ->
            {
                status: 200,
                headers: [],
                body: [],
            }

        Html node ->
            {
                status: 200,
                headers: [
                    httpHeader "Content-Type" "text/html; charset=utf-8",
                ]
                |> appendHxTrigger res.hxTrigger
                |> appendSetCookie res.cookies,
                body: node |> Html.render |> Str.toUtf8,
            }

        StaticHtml node ->
            {
                status: 200,
                headers: [
                    httpHeader "Content-Type" "text/html; charset=utf-8",
                ]
                |> appendHxTrigger res.hxTrigger
                |> appendSetCookie res.cookies,
                body: node |> Html.render |> Str.toUtf8,
            }

        Text body ->
            {
                status: 200,
                headers: [
                    httpHeader "Content-Type" "text/plain; charset=utf-8",

                ]
                |> appendHxTrigger res.hxTrigger
                |> appendSetCookie res.cookies,
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
                |> appendHxTrigger res.hxTrigger
                |> appendSetCookie res.cookies,
                body: Str.toUtf8 "",
            }
