module [a]

import Html
import Html.Attr as Attr
import Hx
import Url exposing [Url]

a : { class ? Str, icon ? Html.Node, href ? Url, target ? Str } -> Html.Node
a = \{ class ? "", icon ? Html.fragment [], href ? Url.fromStr "", target ? "" } ->
    Html.a [Attr.classList [class, "p-3 rounded-full flex items-center justify-center active:opacity-80 hover:opacity-90"], Attr.href (Url.toStr href), Hx.target target] [icon]
