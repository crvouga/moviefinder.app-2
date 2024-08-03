module [view]

import Html
import Html.Attr as Attr

view : { title : Str } -> Html.Node
view = \{ title } ->
    Html.div
        [
            Attr.class "w-full h-16 flex items-center justify-center border-b shrink-0",
        ]
        [
            Html.p [Attr.class "text-lg font-bold"] [Html.text title],
        ]
