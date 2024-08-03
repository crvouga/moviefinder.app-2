module [view]

import Html
import Html.Attr as Attr
import Hx

Action a : {
    label : Str,
    icon : Html.Node,
    value : a,
    href : Str,
}

viewAction : { action : Action a, target : Str, selected : Bool } -> Html.Node
viewAction = \input ->
    Html.a
        [
            Attr.classList [
                if input.selected then
                    "text-blue-600"
                else
                    "",
                "flex-1 h-full flex flex-col text-xs gap- items-center justify-center",
            ],
            Hx.target input.target,
            Hx.swap InnerHtml,
            Attr.href input.action.href,
        ]
        [
            input.action.icon,
            Html.text input.action.label,
        ]

view : { selected : a, target : Str, actions : List (Action a) } -> Html.Node where a implements Eq
view = \input ->
    Html.div
        [Attr.class "w-full h-16 flex items-center justify-center border-b shrink-0 border-t divide-x"]
        (
            List.map input.actions \action -> viewAction {
                    target: input.target,
                    action,
                    selected: (input.selected == action.value),
                }
        )
