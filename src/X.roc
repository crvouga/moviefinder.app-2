# https://alpinejs.dev/
module [data]

import Html.Attr as Attr
import pf.Http
import Url exposing [Url]

data : Str -> Attr.Attribute
data = \javascriptCode -> (Attr.attribute "x-data") javascriptCode

show : Str -> Attr.Attribute
show = \javascriptCode -> (Attr.attribute "x-show") javascriptCode

effect : Str -> Attr.Attribute
effect = \javascriptCode -> (Attr.attribute "x-effect") javascriptCode

ref : Str -> Attr.Attribute
ref = \javascriptCode -> (Attr.attribute "x-ref") javascriptCode

on : Str, Str -> Attr.Attribute
on = \javascriptEventType, javascriptCode -> (Attr.attribute ("x-on:$(javascriptEventType)")) javascriptCode
