module [view]

import Html
import Html.Attr as Attr
import Hx

InputType : [Tel, Text]

inputTypeToHtmlValue : InputType -> Str
inputTypeToHtmlValue = \inputType ->
    when inputType is
        Tel -> "tel"
        Text -> "text"

boolToStr : Bool -> Str
boolToStr = \bool ->
    if bool then
        "true"
    else
        "false"

view : { label : Str, name : Str, inputType ? InputType, required ? Bool } -> Html.Node
view = \{ label, name, inputType ? Text, required ? Bool.false } ->
    Html.div
        [
            Attr.classList [
                "w-full flex flex-col gap-2 transition-opacity",
            ],
            Hx.loadingClassAdd "opacity-70 cursor-not-allowed",
        ]
        [
            Html.label [Attr.class "font-bold"] [Html.text label],
            Html.input [
                Attr.classList [
                    "w-full border bg-neutral-800 p-4 text-xl rounded",
                ],
                Hx.loadingDisabled,
                Attr.name name,
                inputType |> inputTypeToHtmlValue |> Attr.type,
                required |> boolToStr |> Attr.required,
            ],
        ]
