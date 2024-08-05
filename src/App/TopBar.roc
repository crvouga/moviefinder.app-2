module [view]

import Html
import Html.Attr as Attr
import Ui.Icon
import Url
import Route
import Hx

view : { title : Str, back : Route.Route } -> Html.Node
view = \{ title, back } ->
    Html.div
        [
            Attr.class "w-full h-16 flex items-center justify-between border-b shrink-0",
        ]
        [
            Html.a
                [
                    Attr.class "w-16 h-full flex items-center justify-center shrink-0",
                    Attr.href (Url.toStr (Route.encode back)),
                    Hx.target "#app",
                ]
                [
                    Ui.Icon.arrowLeft {},
                ],
            Html.div [Attr.class "truncate text-lg text-center font-bold flex-3"] [Html.text title],
            Html.div
                [
                    Attr.class "w-16 h-full flex items-center justify-center shrink-0",
                ]
                [],
        ]
