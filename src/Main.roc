app [main] {
    pf: platform "https://github.com/roc-lang/basic-webserver/releases/download/0.5.0/Vq-iXfrRf-aHxhJpAh71uoVUlC-rsWvmjzTYOJKhu4M.tar.br",
}

import pf.Stdout
import pf.Task
import pf.Http
import pf.Utc
import Html.Html as Html
import Html.Attr as Attr
import Request
import Response
import Auth.Login
import Hx
import Ctx
import Ui.Spinner as Spinner
import Route
import Feed

viewDocument : { route : Route.Route } -> Html.Node
viewDocument = \{ route } ->
    Html.html [Attr.lang "en"] [
        Html.head
            []
            [
                Html.title [] [Html.text "moviefinder.app"],
                Html.meta [Attr.charset "UTF-8"],
                Html.meta [Attr.name "viewport", Attr.content "width=device-width, initial-scale=1.0"],
                Html.meta [Attr.name "description", Attr.content "Find movies and TV shows to watch."],
                Html.meta [Attr.name "theme-color", Attr.content "#000000"],
                Html.link [Attr.rel "icon", Attr.href "data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 36 36'><text y='32' font-size='32'>🍿</text></svg>"],
                # Html.link [Attr.rel "icon", Attr.href "/favicon.ico"],
                Html.script [Attr.src "https://cdn.tailwindcss.com"] [],
                Html.script [Attr.src "https://unpkg.com/htmx.org@2.0.1", Attr.defer "true"] [],

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
                                Hx.get (Route.encode route),
                            ]
                            [
                                Spinner.view,
                            ],
                    ],
            ],
    ]

routeHx : Ctx.Ctx, Request.Request -> Task.Task Response.Response []
routeHx = \ctx, req ->
    when req.route is
        Login r ->
            Auth.Login.routeHx ctx r

        Feed r ->
            Feed.routeHx r

        Index | RobotsTxt ->
            Route.init |> Response.redirect |> Task.ok

routeReq : Request.Request -> Task.Task Response.Response []
routeReq = \req ->
    when req.route is
        RobotsTxt ->
            robotsTxt : Str
            robotsTxt =
                """
                User-agent: *
                Allow: /
                """
            Response.text robotsTxt |> Task.ok

        _ ->
            route : Route.Route
            route =
                when req.route is
                    Index -> Route.init
                    _ -> req.route

            viewDocument { route }
            |> Response.html
            |> Task.ok

baseCtx = Ctx.init

log : Request.Request -> Task.Task _ []
log = \req ->
    date = Utc.now! |> Utc.toIso8601Str
    Stdout.line! "$(date) $(Inspect.toStr req)"

main : Http.Request -> Task.Task Http.Response []
main = \httpReq ->
    req = Request.fromHttp httpReq
    log! req
    res =
        if
            Hx.isReq httpReq
        then
            routeHx baseCtx req
        else
            routeReq req
    res |> Task.map Response.toHttp
