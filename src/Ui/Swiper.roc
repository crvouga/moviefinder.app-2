module [container, slide, direction, slidesPerView]

import Html
import Html.Attr as Attr

container = Html.element "swiper-container"

slide = Html.element "swiper-slide"

slidesPerView : U64 -> Attr.Attribute
slidesPerView = \slidesPerViewValue -> (Attr.attribute "slides-per-view") (Num.toStr slidesPerViewValue)

Direction : [Horizontal, Vertical]

directionToStr : Direction -> Str
directionToStr = \directionValue ->
    when directionValue is
        Horizontal -> "horizontal"
        Vertical -> "vertical"

direction : Direction -> Attr.Attribute
direction = \directionValue -> (Attr.attribute "direction") (directionToStr directionValue)

