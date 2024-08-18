module [view]

import Html
import Html.Attr
import Route
import Url
import Hx

view : { route : Route.Route, label : Str, attrs ? List Html.Attr.Attribute }, List Html.Node -> Html.Node
view = \{ route, label, attrs ? [] }, children ->
    Html.a
        (
            List.concat attrs [
                Html.Attr.label label,
                (Html.Attr.attribute "aria-label") label,
                Hx.target "#app",
                Hx.swap InnerHtml,
                Html.Attr.href (Url.toStr (Route.encode route)),
            ]
        )
        children
