module [view]

import Html
import Html.Attr
import Route
import Url
import Hx

view : Route.Route, List Html.Attr.Attribute, List Html.Node -> Html.Node
view = \route, attrs, children ->
    Html.a
        (
            List.concat attrs [
                Hx.target "#app",
                Hx.swap InnerHtml,
                Html.Attr.href (Url.toStr (Route.encode route)),
            ]
        )
        children
