module [
    view,
    routeHx,
]

import Html
import Html.Attr as Attr
import Ui.Button as Button
import Ui.TopBar as TopBar
import Response
import pf.Task

routeHx : _ -> Task.Task Response.Response []
routeHx = \_ ->
    view
    |> Response.html
    |> Task.ok

view : Html.Node
view = Html.div [Attr.class "w-full h-full flex flex-col"] [
    TopBar.view { title: "Home" },
    Html.div
        [
            Attr.class "flex flex-col w-full flex-1 p-4 gap-8",
        ]
        [
            Button.view { label: "Login", href: "/login" },
        ],
]
