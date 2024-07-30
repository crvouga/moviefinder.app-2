module [view]

import Html.Html as Html
import Html.Attr as Attr

InputType : [Tel, Text]

inputTypeToHtmlValue : InputType -> Str
inputTypeToHtmlValue = \inputType ->
    when inputType is
        Tel -> "tel"
        Text -> "text"

view : { label : Str, inputType ? InputType } -> Html.Node
view = \{ label, inputType ? Text } ->
    Html.div
        [
            Attr.class "w-full flex flex-col gap-2",
        ]
        [
            Html.label [Attr.class "font-bold"] [Html.text label],
            Html.input [
                Attr.class "w-full border bg-neutral-800 p-3 text-lg rounded",
                inputType |> inputTypeToHtmlValue |> Attr.type,
            ],
        ]
