module [swap, trigger, get, boost, target, isReq, post, pushUrl, loadingScope, loadingClassAdd, loadingClassRemove, extensions, loadingPath, loadingAriaBusy, loadingDisabled, abort]

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

post : Url -> Attr.Attribute
post = \url -> (Attr.attribute "hx-post") (Url.toStr url)

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

pushUrl : Attr.Attribute
pushUrl = (Attr.attribute "hx-push-url") "true"

# https://v1.htmx.org/extensions/loading-states/

loadingClassAdd : Str -> Attr.Attribute
loadingClassAdd = Attr.attribute "data-loading-class"

loadingClassRemove : Str -> Attr.Attribute
loadingClassRemove = Attr.attribute "data-loading-class-remove"

loadingScope : Attr.Attribute
loadingScope = (Attr.attribute "data-loading-states") ""

loadingPath : Url -> Attr.Attribute
loadingPath = \url -> (Attr.attribute "data-loading-path") (Url.toStr url)

extensions : List Str -> Attr.Attribute
extensions = \extenstionList -> (Attr.attribute "hx-ext") (Str.joinWith extenstionList " ")

loadingAriaBusy : Attr.Attribute
loadingAriaBusy = (Attr.attribute "data-loading-aria-busy") ""

loadingDisabled : Attr.Attribute
loadingDisabled = (Attr.attribute "data-loading-disable") ""

abort : Str -> Str
abort = \cssSelector ->
    "htmx.trigger('$(cssSelector)', 'htmx:abort')"
