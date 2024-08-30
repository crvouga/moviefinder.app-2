module [view]

import Html
import Html.Attr as Attr

view : { label : Str, selected ? Bool } -> Html.Node
view = \{ label, selected ? Bool.false } ->
    Html.button
        [
            Attr.classList [
                "px-2 py-1 rounded-full w-fit font-bold border hover:bg-neutral-800 hover:text-white",
                if selected then
                    "text-white"
                else
                    "bg-transparent text-black",
            ],
        ]
        [
            Html.text label,
        ]
