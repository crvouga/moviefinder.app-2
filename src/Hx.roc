module [hxSwap, hxTrigger, hxGet, hxBoost]

import Html.Attr as Attr

hxSwap : Str -> Attr.Attribute
hxSwap = Attr.attribute "hx-swap"

hxTrigger : Str -> Attr.Attribute
hxTrigger = Attr.attribute "hx-trigger"

hxGet : Str -> Attr.Attribute
hxGet = Attr.attribute "hx-get"

hxBoost : Str -> Attr.Attribute
hxBoost = Attr.attribute "hx-boost"
