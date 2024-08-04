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

view : { text : Str, variant ? Variant, class ? Str } -> Html.Node
view = \{ text, variant ? Body, class ? "" } ->
    (Html.element (variantToHtmlTag variant))
        [
            Attr.classList [class],
        ]
        [
            Html.text text,
        ]
