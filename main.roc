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
                        (Attr.attribute "hx-swap") "innerHTML",
                        (Attr.attribute "hx-trigger") "load",
                        (Attr.attribute "hx-get") "/home",
                    ]
                    [
                        Html.p [] [Html.text "Loading..."],
                    ],
            ],
    ]

main : Request -> Task Response []
main = \req ->

    date = Utc.now! |> Utc.toIso8601Str
    Stdout.line! "$(date) $(Http.methodToStr req.method) $(req.url)"

    if req.url == "/home" then
        Task.ok {
            status: 200,
            headers: [],
            body: Home.view |> Html.render |> Str.toUtf8,
        }
    else
        Task.ok {
            status: 200,
            headers: [],
            body: document |> Html.render |> Str.toUtf8,
        }

