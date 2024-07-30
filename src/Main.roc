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

document : Html.Node
document =
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
                                (Attr.attribute "hx-get") "/home",
                            ]
                            [Html.text "Loading..."],
                    ],
            ],
    ]

routeHx : Request -> Task Response []
routeHx = \req ->
    when req.url is
        "/home" ->
            Response.html Home.view |> Task.ok

        "/media" ->
            Response.html Media.view |> Task.ok

        _ ->
            Response.html document |> Task.ok

routeReq : Request -> Task Response []
routeReq = \_req ->
    Response.html document |> Task.ok

main : Request -> Task Response []
main = \req ->

    date = Utc.now! |> Utc.toIso8601Str
    Stdout.line! "$(date) $(Http.methodToStr req.method) $(req.url)"

    isHxRequest = List.any req.headers (\header -> header.name == "hx-request")

    if isHxRequest then
        routeHx req
    else
        routeReq req
