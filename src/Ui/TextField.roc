module [view]

import Html
import Html.Attr as Attr

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

view : { label : Str, inputType ? InputType, required ? Bool } -> Html.Node
view = \{ label, inputType ? Text, required ? Bool.false } ->
    Html.div
        [
            Attr.class "w-full flex flex-col gap-2",
        ]
        [
            Html.label [Attr.class "font-bold"] [Html.text label],
            Html.input [
                Attr.class "w-full border bg-neutral-800 p-4 text-xl rounded",
                inputType |> inputTypeToHtmlValue |> Attr.type,
                required |> boolToStr |> Attr.required,
            ],
        ]
