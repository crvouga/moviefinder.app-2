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
import Auth.Login
import Hx
import Ctx
import Ui.Spinner as Spinner

viewDocument : { pageHref : Str } -> Html.Node
viewDocument = \{ pageHref } ->
    Html.html [] [
        Html.head
            []
            [
                Html.title [] [Html.text "moviefinder.app"],
                Html.meta [Attr.charset "UTF-8"],
                Html.meta [Attr.name "viewport", Attr.content "width=device-width, initial-scale=1.0"],
                Html.meta [Attr.name "theme-color", Attr.content "#000000"],
                Html.link [Attr.rel "icon", Attr.href "data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 36 36'><text y='32' font-size='32'>🍿</text></svg>"],
                Html.link [Attr.rel "icon", Attr.href "/favicon.ico"],
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
                        Hx.boost Bool.true,
                    ]
                    [
                        Html.div
                            [
                                Attr.class "flex items-center justify-center w-full h-full",
                                Hx.swap OuterHtml,
                                Hx.trigger Load,
                                Hx.get pageHref,
                            ]
                            [
                                Spinner.view,
                            ],
                    ],
            ],
    ]

Route : [Home, Media, Login Auth.Login.Route, Unknown]

strToRoute : Str -> Route
strToRoute = \str ->
    loginRoute = Auth.Login.strToRoute str
    if loginRoute == Unknown then
        when str is
            "/home" -> Home
            "/media" -> Media
            _ -> Unknown
    else
        Login loginRoute

routeHx : Ctx.Ctx, Http.Request -> Task.Task Http.Response []
routeHx = \ctx, req ->
    when strToRoute req.url is
        Login _ ->
            Auth.Login.routeHx ctx req

        Home ->
            Home.view |> Response.html |> Task.ok

        Media ->
            Media.view |> Response.html |> Task.ok

        Unknown ->
            "/home" |> Response.redirect |> Task.ok

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
    |> \pageHref -> viewDocument { pageHref }
    |> Response.html
    |> Task.ok

main : Http.Request -> Task.Task Http.Response []
main = \req ->

    date = Utc.now! |> Utc.toIso8601Str
    Stdout.line! "$(date) $(Http.methodToStr req.method) $(req.url)"

    if Hx.isReq req then
        routeHx Ctx.init req
    else
        routeReq req
