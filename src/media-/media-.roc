module [Media, view]

import Html.Html as Html
import Html.Attribute as Attr

MediaType : [Movie, Tv]

Media : {
    mediaTitle : Str,
    mediaDescription : Str,
    mediaType : MediaType,
    mediaPosterUrl : Str,
}

view : Html.Node
view = Html.div [] [
    Html.h1 [] [Html.text "Hello, World! Media.roc"],
    Html.p [] [Html.text "This is a simple Roc web app."],
    Html.a
        [
            Attr.href "/home",
            Attr.class "underline text-blue-500",
            (Attr.attribute "hx-target") "#app",
        ]
        [
            Html.text "Go to Home",
        ],
    Html.p [] [
        Html.text "You should really check out ",
        Html.a [Attr.href "https://roc-lang.org/"] [Html.text "Roc"],
        Html.text "!",
    ],
]
