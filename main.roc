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

document =
    Html.html [] [
        Html.head
            []
            [
                Html.title [] [Html.text "moviefinder.app"],
                Html.script [Attr.src "https://cdn.tailwindcss.com"] [],
            ],
        Html.body
            [Attr.class "bg-black text-white flex flex-col items-center justify-center w-full h-screen"]
            [Html.div [Attr.class "w-full max-w-[500px] h-full max-h-[800px] border rounded overflow-hidden"] [Home.view]],
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
