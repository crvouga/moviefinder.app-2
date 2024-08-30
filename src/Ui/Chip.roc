module [view]

import Html
import Html.Attr as Attr

view : { label : Str, selected ? Bool } -> Html.Node
view = \{ label, selected ? Bool.false } -> Html.div
        [
            Attr.classList [
                "px-2 py-1 rounded-full w-fit font-bold border",
                if selected then
                    "bg-primary-200 text-white"
                else
                    "bg-transparent text-black",
            ],
        ]
        [
            Html.text label,
        ]
