module [view]

import Html
import Html.Attr as Attr

Variant : [H1, H2, H3, H4, H5, H6, Body, Caption, Overline, Subtitle]

variantToHtmlTag : Variant -> Str
variantToHtmlTag = \variant ->
    when variant is
        H1 -> "h1"
        H2 -> "h2"
        H3 -> "h3"
        H4 -> "h4"
        H5 -> "h5"
        H6 -> "h6"
        Body -> "p"
        Caption -> "caption"
        Overline -> "span"
        Subtitle -> "span"

variantToClass : Variant -> Str
variantToClass = \variant ->
    when variant is
        H1 -> "text-4xl font-bold"
        H2 -> "text-3xl font-bold"
        H3 -> "text-2xl font-bold"
        H4 -> "text-xl font-bold"
        H5 -> "text-lg font-bold"
        H6 -> "text-base font-bold"
        Body -> "text-base"
        Caption -> "text-sm"
        Overline -> "text-xs"
        Subtitle -> "text-lg"

view : { text : Str, variant ? Variant, class ? Str } -> Html.Node
view = \{ text, variant ? Body, class ? "" } ->
    (Html.element (variantToHtmlTag variant))
        [
            Attr.classList [variantToClass variant, class],
        ]
        [
            Html.text text,
        ]
