app [main] {
    pf: platform "https://github.com/roc-lang/basic-webserver/releases/download/0.4.0/iAiYpbs5zdVB75golcg_YMtgexN3e2fwhsYPLPCeGzk.tar.br",
}

import pf.Stdout
import pf.Task exposing [Task]
import pf.Http exposing [Request, Response]
import pf.Utc
import Html.Html as Html
import Html.Attribute as Attr

document =
    Html.html [] [
        Html.head
            []
            [
                Html.title [] [Html.text "moviefinder.app"],
                Html.script [Attr.src "https://cdn.tailwindcss.com"] [],
            ],
        Html.body
            [
                Attr.class "bg-black text-white",
            ]
            [
                Html.h1
                    [
                        Attr.class "text-4xl font-bold text-center text-blue-500",
                    ]
                    [
                        Html.text "Movie finder",
                    ],
                Html.p [] [
                    Html.text "You should really check out ",
                    Html.a [Attr.href "https://roc-lang.org/"] [Html.text "Roc"],
                    Html.text "!",
                ],
            ],
    ]
    |> Html.render

main : Request -> Task Response []
main = \req ->

    date = Utc.now! |> Utc.toIso8601Str
    Stdout.line! "$(date) $(Http.methodToStr req.method) $(req.url)"

    Task.ok {
        status: 200,
        headers: [],
        body: Str.toUtf8 document,
    }
