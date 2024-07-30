module [
    view,
]

import Html.Html as Html
import Html.Attr as Attr

view : Html.Node
view = Html.div [] [
    Html.h1 [] [Html.text "Hello, World!"],
    Html.p [] [Html.text "This is a simple Roc web app."],
    Html.a
        [
            Attr.href "/media",
            Attr.class "underline text-blue-500",
            (Attr.attribute "hx-target") "#app",
        ]
        [
            Html.text "Go to Media",
        ],
    Html.p [] [
        Html.text "You should really check out ",
        Html.a [Attr.href "https://roc-lang.org/"] [Html.text "Roc"],
        Html.text "!",
    ],
]
