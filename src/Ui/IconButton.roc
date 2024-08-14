module [view]

import Html
import Html.Attr as Attr
import Hx
import Url exposing [Url]

view : { class ? Str, icon ? Html.Node, href ? Url, target ? Str } -> Html.Node
view = \{ class ? "", icon ? Html.fragment [], href ? Url.fromStr "", target ? "" } ->
    Html.a [Attr.classList [class, "p-3 rounded-full flex items-center justify-center active:opacity-80 hover:opacity-90"], Hx.get href, Hx.target target] [icon]
