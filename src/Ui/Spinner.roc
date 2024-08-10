module [view]

import Html
import Ui.Icon

view : { class ? Str } -> Html.Node
view = \{ class ? "size-12" } ->
    Ui.Icon.spinner { class: "animate-spin $(class)" }
