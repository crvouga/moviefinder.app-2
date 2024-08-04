module [view]

import Html
import Html.Attr as Attr

view : List Attr.Attribute -> Html.Node
view = \attrs -> (Html.element "image-element") attrs []

