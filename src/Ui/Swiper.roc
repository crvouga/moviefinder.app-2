module [container, slide, Config]

import Html
import Html.Attr as Attr

Direction : [Horizontal, Vertical]

directionToStr : Direction -> Str
directionToStr = \direction ->
    when direction is
        Horizontal -> "horizontal"
        Vertical -> "vertical"

Config : {
    slidesPerView ? I32,
    direction ? Direction,
    classList ? List Str,
}

swiperContainer = Html.element "swiper-container"
slidesPerViewAttr = Attr.attribute "slides-per-view"
directionAttr = Attr.attribute "direction"

container : Config, List Html.Node -> Html.Node
container = \{ slidesPerView ? 1, direction ? Vertical, classList ? [] }, children ->
    swiperContainer
        [
            slidesPerView |> Num.toStr |> slidesPerViewAttr,
            direction |> directionToStr |> directionAttr,
            Attr.classList classList,
        ]
        children

swiperSlide = Html.element "swiper-slide"

slide : List Html.Node -> Html.Node
slide = \children ->
    swiperSlide [] children
