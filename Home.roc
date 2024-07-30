module [
    view,
]

import Html.Html as Html
import Html.Attribute as Attr

view = Html.div [] [
    Html.h1 [] [Html.text "Hello, World!"],
    Html.p [] [Html.text "This is a simple Roc web app."],
    Html.p [] [
        Html.text "You should really check out ",
        Html.a [Attr.href "https://roc-lang.org/"] [Html.text "Roc"],
        Html.text "!",
    ],
]
