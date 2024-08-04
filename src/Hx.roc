module [swap, trigger, get, boost, target, isReq]

import Html.Attr as Attr
import pf.Http
import Url exposing [Url]

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

TriggerValue : [Load, Click, Submit, Input, Change, Keyup, Keydown, Keypress, Revealed, Intersect]

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
        Revealed -> "revealed"
        Intersect -> "intersect"

trigger : TriggerValue -> Attr.Attribute
trigger = \triggerValue -> triggerValue |> triggerValueToStr |> (Attr.attribute "hx-trigger")

get : Url -> Attr.Attribute
get = \url -> (Attr.attribute "hx-get") (Url.toStr url)

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

isReq : Http.Request -> Bool
isReq = \req -> List.any req.headers (\header -> header.name == "hx-request")
