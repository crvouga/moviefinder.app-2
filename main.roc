app [main] {
    pf: platform "https://github.com/roc-lang/basic-webserver/releases/download/0.4.0/iAiYpbs5zdVB75golcg_YMtgexN3e2fwhsYPLPCeGzk.tar.br",
}

import pf.Stdout
import pf.Task exposing [Task]
import pf.Http exposing [Request, Response]
import pf.Utc
import Html.Html as Html
import Html.Attribute as Attribute

document =
    Html.html [] [
        Html.body [] [
            Html.h1 [] [Html.text "Roc"],
            Html.p [] [
                Html.text "You should really check out ",
                Html.a [Attribute.href "https://roc-lang.org/"] [Html.text "Roc"],
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
