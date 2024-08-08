# https://alpinejs.dev/
module [data, show, effect, ref, on]

import Html.Attr as Attr

data : Str -> Attr.Attribute
data = \javascriptCode -> (Attr.attribute "x-data") javascriptCode

show : Str -> Attr.Attribute
show = \javascriptCode -> (Attr.attribute "x-show") javascriptCode

effect : Str -> Attr.Attribute
effect = \javascriptCode -> (Attr.attribute "x-effect") javascriptCode

ref : Str -> Attr.Attribute
ref = \javascriptCode -> (Attr.attribute "x-ref") javascriptCode

EventType : [Click, Custom Str]

eventTypeToStr : EventType -> Str
eventTypeToStr = \eventType ->
    when eventType is
        Click -> "click"
        Custom str -> str

on : EventType, Str -> Attr.Attribute
on = \eventType, javascriptCode -> (Attr.attribute ("x-on:$(eventTypeToStr eventType)")) javascriptCode
