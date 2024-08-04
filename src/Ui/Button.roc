module [view]

import Html
import Html.Attr as Attr
import Hx
import Url exposing [Url]

view : { label : Str, href : Url, target : Str, class ? Str } -> Html.Node
view = \input ->
    { class ? "" } = input
    Html.a
        [
            Attr.classList [
                "px-4 py-3 bg-blue-600 text-lg text-white rounded font-bold hover:opacity-90 active:opacity-80 flex items-center justify-center",
                class,
            ],
            Attr.href (Url.toStr input.href),
            Hx.target input.target,

        ]
        [Html.text input.label]
