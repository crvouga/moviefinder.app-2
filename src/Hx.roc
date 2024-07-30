module [swap, trigger, get, boost, target]

import Html.Attr as Attr

SwapValue : [InnerHtml, OuterHtml, InnerText, OuterText]

swapValueToStr : SwapValue -> Str
swapValueToStr = \swapValue ->
    when swapValue is
        InnerHtml -> "innerHTML"
        OuterHtml -> "outerHTML"
        InnerText -> "innerText"
        OuterText -> "outerText"

swap : SwapValue -> Attr.Attribute
swap = \swapValue -> swapValue |> swapValueToStr |> (Attr.attribute "hx-swap")

TriggerValue : [Load, Click, Submit, Input, Change, Keyup, Keydown, Keypress]

triggerValueToStr : TriggerValue -> Str
triggerValueToStr = \triggerValue ->
    when triggerValue is
        Load -> "load"
        Click -> "click"
        Submit -> "submit"
        Input -> "input"
        Change -> "change"
        Keyup -> "keyup"
        Keydown -> "keydown"
        Keypress -> "keypress"

trigger : TriggerValue -> Attr.Attribute
trigger = \triggerValue -> triggerValue |> triggerValueToStr |> (Attr.attribute "hx-trigger")

get : Str -> Attr.Attribute
get = Attr.attribute "hx-get"

boolToHtmlBool : Bool.Bool -> Str
boolToHtmlBool = \bool ->
    if bool then
        "true"
    else
        "false"

boost : Bool -> Attr.Attribute
boost = \bool -> bool |> boolToHtmlBool |> (Attr.attribute "hx-boost")

target : Str -> Attr.Attribute
target = Attr.attribute "hx-target"
