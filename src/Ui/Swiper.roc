module [container, slide, direction, slidesPerView, speed, initialSlide]

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

speed : U64 -> Attr.Attribute
speed = \speedValue -> (Attr.attribute "speed") (Num.toStr speedValue)

initialSlide : U64 -> Attr.Attribute
initialSlide = \initialSlideValue -> (Attr.attribute "initial-slide") (Num.toStr initialSlideValue)
