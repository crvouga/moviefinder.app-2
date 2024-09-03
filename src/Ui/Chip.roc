module [view]

import Html
import Html.Attr as Attr

view : { label : Str, selected ? Bool }, List Attr.Attribute -> Html.Node
view = \{ label, selected ? Bool.false }, attrs ->
    Html.button
        (
            List.concat
                [
                    Attr.classList [
                        "px-2 py-1 rounded-full w-fit font-bold border hover:bg-neutral-800 hover:text-white",
                        if selected then
                            "text-white"
                        else
                            "bg-transparent text-black",
                    ],
                ]
                attrs
        )
        [
            Html.text label,
        ]
