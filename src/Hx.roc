module [hxSwap, hxTrigger, hxGet, hxBoost, hxTarget]

import Html.Attr as Attr

HxSwapValue : [InnerHtml, OuterHtml, InnerText, OuterText]

hxSwapValueToStr : HxSwapValue -> Str
hxSwapValueToStr = \hxSwapValue ->
    when hxSwapValue is
        InnerHtml -> "innerHTML"
        OuterHtml -> "outerHTML"
        InnerText -> "innerText"
        OuterText -> "outerText"

hxSwap : HxSwapValue -> Attr.Attribute
hxSwap = \hxSwapValue -> hxSwapValue |> hxSwapValueToStr |> (Attr.attribute "hx-swap")

HxTriggerValue : [Load, Click, Submit, Input, Change, Keyup, Keydown, Keypress]

hxTriggerValueToStr : HxTriggerValue -> Str
hxTriggerValueToStr = \hxTriggerValue ->
    when hxTriggerValue is
        Load -> "load"
        Click -> "click"
        Submit -> "submit"
        Input -> "input"
        Change -> "change"
        Keyup -> "keyup"
        Keydown -> "keydown"
        Keypress -> "keypress"

hxTrigger : HxTriggerValue -> Attr.Attribute
hxTrigger = \hxTriggerValue -> hxTriggerValue |> hxTriggerValueToStr |> (Attr.attribute "hx-trigger")

hxGet : Str -> Attr.Attribute
hxGet = Attr.attribute "hx-get"

boolToHtmlBool : Bool.Bool -> Str
boolToHtmlBool = \bool ->
    if bool then
        "true"
    else
        "false"

hxBoost : Bool -> Attr.Attribute
hxBoost = \bool -> bool |> boolToHtmlBool |> (Attr.attribute "hx-boost")

hxTarget : Str -> Attr.Attribute
hxTarget = Attr.attribute "hx-target"
