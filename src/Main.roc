app [main] {
    pf: platform "https://github.com/roc-lang/basic-webserver/releases/download/0.5.0/Vq-iXfrRf-aHxhJpAh71uoVUlC-rsWvmjzTYOJKhu4M.tar.br",
}

import pf.Stdout
import pf.Task
import pf.Http
import pf.Utc
import Html.Html as Html
import Html.Attr as Attr
import Home
import Media.Media as Media
import Response
import Hx

viewDocument : { pageHref : Str } -> Html.Node
viewDocument = \{ pageHref } ->
    Html.html [] [
        Html.head
            []
            [
                Html.title [] [Html.text "moviefinder.app"],
                Html.meta [Attr.charset "UTF-8"],
                Html.meta [Attr.name "viewport", Attr.content "width=device-width, initial-scale=1.0"],
                Html.script [Attr.src "https://cdn.tailwindcss.com"] [],
                Html.script [Attr.src "https://unpkg.com/htmx.org@2.0.1"] [],

            ],
        Html.body
            [
                Attr.class "bg-black text-white flex flex-col items-center justify-center w-full h-[100dvh] max-h-[100dvh]",
            ]
            [
                Html.div
                    [
                        Attr.class "w-full max-w-[500px] h-full max-h-[800px] border rounded overflow-hidden",
                        Attr.id "app",
                        Hx.hxBoost Bool.true,
                    ]
                    [
                        Html.p
                            [
                                Hx.hxSwap OuterHtml,
                                Hx.hxTrigger Load,
                                Hx.hxGet pageHref,
                            ]
                            [Html.text "Loading..."],
                    ],
            ],
    ]

routeHx : Http.Request -> Task.Task Http.Response []
routeHx = \req ->
    when req.url is
        "/home" ->
            Home.view |> Response.html |> Task.ok

        "/media" ->
            Media.view |> Response.html |> Task.ok

        _ ->
            Home.view |> Response.html |> Task.ok

toDefaultRoute : Http.Request -> Str
toDefaultRoute = \req ->
    if
        req.url == "/"
    then
        "/home"
    else
        req.url

routeReq : Http.Request -> Task.Task Http.Response []
routeReq = \req ->
    req
    |> toDefaultRoute
    |> \pageHref -> { pageHref }
    |> viewDocument
    |> Response.html
    |> Task.ok

main : Http.Request -> Task.Task Http.Response []
main = \req ->

    date = Utc.now! |> Utc.toIso8601Str
    Stdout.line! "$(date) $(Http.methodToStr req.method) $(req.url)"

    isHxRequest = List.any req.headers (\header -> header.name == "hx-request")

    if isHxRequest then
        routeHx req
    else
        routeReq req
