module [view]

import Html
import Html.Attr as Attr

view : { class ? Str, icon ? Html.Node } -> Html.Node
view = \{ class ? "", icon ? Html.fragment [] } ->
    Html.button [Attr.classList [class, "p-3 rounded-full flex items-center justify-center active:opacity-80 hover:opacity-90"]] [icon]
