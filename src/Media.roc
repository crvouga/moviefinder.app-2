module [Media, view, testData]

import Html
import Html.Attr as Attr
import Ui.Button as Button

MediaType : [Movie, Tv]

Media : {
    mediaId : Str,
    mediaTitle : Str,
    mediaDescription : Str,
    mediaType : MediaType,
    mediaPosterUrl : Str,
}

testData : List Media
testData = [
    {
        mediaId: "1",
        mediaTitle: "Some Movie",
        mediaDescription: "My movie",
        mediaType: Movie,
        mediaPosterUrl: "",
    },
    {
        mediaId: "2",
        mediaTitle: "Some Tv Show",
        mediaDescription: "My tv",
        mediaType: Tv,
        mediaPosterUrl: "",
    },
]

view : Html.Node
view = Html.div [] [
    Html.h1 [] [Html.text "Hello, World! Media.roc"],
    Html.p [] [Html.text "This is a simple Roc web app."],
    Button.view {
        label: "Go home",
        href: "/home",
        target: "#app",
    },
    Html.p [] [
        Html.text "You should really check out ",
        Html.a [Attr.href "https://roc-lang.org/"] [Html.text "Roc"],
        Html.text "!",
    ],
]
