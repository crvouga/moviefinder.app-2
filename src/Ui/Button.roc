module [view]

import Html.Html as Html
import Html.Attr as Attr
import Hx

view : { label : Str, href : Str } -> Html.Node
view = \{ label, href } ->
    Html.a
        [
            Attr.class "px-4 py-2 bg-blue-500 text-white rounded font-bold",
            Attr.href href,
            Hx.hxTarget "#app",

        ]
        [Html.text label]
