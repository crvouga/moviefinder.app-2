module [view, Config]

import Html
import Html.Attr as Attr

Config : {}

view : Config -> Html.Node
view = \{} ->
    (Html.element "swiper-feed-element") [Attr.class "w-full h-full"] []
