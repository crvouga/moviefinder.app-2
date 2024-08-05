module [a, button]

import Html
import Html.Attr as Attr
import Hx
import Url exposing [Url]

baseClass : Str
baseClass = "px-4 py-3 bg-blue-600 text-lg text-white rounded font-bold hover:opacity-90 active:opacity-80 flex items-center justify-center"

a : { label : Str, href : Url, target : Str, class ? Str } -> Html.Node
a = \input ->
    { class ? "" } = input
    Html.a
        [
            Attr.classList [
                baseClass,
                class,
            ],
            Attr.href (Url.toStr input.href),
            Hx.target input.target,

        ]
        [Html.text input.label]

button : List Attr.Attribute, { label : Str, class ? Str } -> Html.Node
button = \attrs, input ->
    { class ? "" } = input
    Html.button
        (
            List.concat attrs [
                Attr.classList [
                    baseClass,
                    class,
                ],
            ]
        )
        [Html.text input.label]
