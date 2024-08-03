module [view]

import Html
import Html.Attr as Attr
import Hx

view : { label : Str, href : Str, target : Str, class ? Str } -> Html.Node
view = \input ->
    { class ? "" } = input
    Html.a
        [
            Attr.classList [
                "px-4 py-3 bg-blue-600 text-lg text-white rounded font-bold hover:opacity-90 active:opacity-80 flex items-center justify-center",
                class,
            ],
            Attr.href input.href,
            Hx.target input.target,

        ]
        [Html.text input.label]
