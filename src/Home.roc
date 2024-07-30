module [
    view,
]

import Html.Html as Html
import Html.Attr as Attr
import Ui.Button as Button

view : Html.Node
view = Html.div [] [
    Html.h1 [] [Html.text "Hello, World!"],
    Html.p [] [Html.text "This is a simple Roc web app."],
    Button.view { label: "Go media", href: "/media" },
    Html.p [] [
        Html.text "You should really check out ",
        Html.a [Attr.href "https://roc-lang.org/"] [Html.text "Roc"],
        Html.text "!",
    ],
]
