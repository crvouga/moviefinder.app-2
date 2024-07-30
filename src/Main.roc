app [main] {
    pf: platform "https://github.com/roc-lang/basic-webserver/releases/download/0.4.0/iAiYpbs5zdVB75golcg_YMtgexN3e2fwhsYPLPCeGzk.tar.br",
}

import pf.Stdout
import pf.Task exposing [Task]
import pf.Http exposing [Request, Response]
import pf.Utc
import Html.Html as Html
import Html.Attribute as Attr
import Home
import Media
import Response

viewDocument : { pageHref : Str } -> Html.Node
viewDocument = \{ pageHref } ->
    Html.html [] [
        Html.head
            []
            [
                Html.title [] [Html.text "moviefinder.app"],
                Html.script [Attr.src "https://cdn.tailwindcss.com"] [],
                Html.script [Attr.src "https://unpkg.com/htmx.org@2.0.1"] [],
            ],
        Html.body
            [Attr.class "bg-black text-white flex flex-col items-center justify-center w-full h-screen"]
            [
                Html.div
                    [
                        Attr.class "w-full max-w-[500px] h-full max-h-[800px] border rounded overflow-hidden",
                        Attr.id "app",
                        (Attr.attribute "hx-boost") "true",
                    ]
                    [
                        Html.p
                            [
                                (Attr.attribute "hx-swap") "outerHTML",
                                (Attr.attribute "hx-trigger") "load",
                                (Attr.attribute "hx-get") pageHref,
                            ]
                            [Html.text "Loading..."],
                    ],
            ],
    ]

routeHx : Request -> Task Response []
routeHx = \req ->
    when req.url is
        "/home" ->
            Home.view |> Response.html |> Task.ok

        "/media" ->
            Media.view |> Response.html |> Task.ok

        _ ->
            { pageHref: req.url } |> viewDocument |> Response.html |> Task.ok

routeReq : Request -> Task Response []
routeReq = \req ->
    { pageHref: req.url } |> viewDocument |> Response.html |> Task.ok

main : Request -> Task Response []
main = \req ->

    date = Utc.now! |> Utc.toIso8601Str
    Stdout.line! "$(date) $(Http.methodToStr req.method) $(req.url)"

    isHxRequest = List.any req.headers (\header -> header.name == "hx-request")

    if isHxRequest then
        routeHx req
    else
        routeReq req
