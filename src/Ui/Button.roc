module [a, button]

import Html
import Html.Attr as Attr
import Hx
import Url exposing [Url]
import Ui.Spinner

baseClass : Str
baseClass =
    [
        "px-4 py-3 bg-blue-600 text-lg text-white rounded font-bold flex items-center justify-center relative",
        "enabled:hover:opacity-90 enabled:active:opacity-50",
        "disabled:opacity-80 disabled:cursor-not-allowed",
        "aria-busy:opacity-80 aria-busy:cursor-progress",
    ]
    |> Str.joinWith " "

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
                Hx.loadingAriaBusy,
                Hx.loadingDisabled,
                Attr.classList [
                    baseClass,
                    class,
                ],
            ]
        )
        [
            Html.div
                [
                    Attr.class "opacity-0 absolute top-0 left-0 w-full h-full flex items-center justify-center transition-opacity",
                    Hx.loadingClassRemove "opacity-0",
                    Hx.loadingClassAdd "opacity-100",

                ]
                [Ui.Spinner.view { class: "size-8" }],
            Html.div
                [
                    Attr.class "transition-opacity",
                    Hx.loadingClassAdd "opacity-0",
                ]
                [Html.text input.label],
        ]
