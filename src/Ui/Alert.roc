module [view]

import Html
import Html.Attr as Attr

AlertVariant : [Error]

variantToClass : AlertVariant -> Str
variantToClass = \variant ->
    when variant is
        Error -> "bg-red-800 border border-red-500 text-white"

view : { variant : AlertVariant, text : Str } -> Html.Node
view = \input ->
    Html.div
        [
            Attr.classList [
                "rounded p-4 flex flex-row items-center gap-2",
                variantToClass input.variant,
            ],
        ]
        [
            Html.p [Attr.class "text-sm opacity-80"] [Html.text input.text],
        ]
