module [view]

import Html.Html as Html
import Html.Attr as Attr
import Hx

view : { label : Str, href : Str } -> Html.Node
view = \{ label, href } ->
    Html.a
        [
            Attr.class "px-4 py-3 bg-blue-600 text-lg text-white rounded font-bold hover:opacity-90 active:opacity-80",
            Attr.href href,
            Hx.target "#app",

        ]
        [Html.text label]
