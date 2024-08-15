module [
    routeHx,
]

import Response
import pf.Task
import Html
import Feed.Controls.Route
import Feed.Route
import Ctx
import Ui.Icon
import Html.Attr as Attr
import Ui.IconButton

routeHx : Ctx.Ctx, Feed.Controls.Route.Route -> Task.Task Response.Response _
routeHx = \_ctx, route ->
    when route is
        Controls ->
            viewControls |> Response.html |> Task.ok

        ControlsLoad ->
            Response.redirect (Feed Feed) |> Task.ok

        Unknown ->
            Response.redirect (Feed Feed) |> Task.ok

viewControls : Html.Node
viewControls =
    Html.div [] [
        Html.div
            [
                Attr.class "w-full h-16 flex items-center justify-start overflow-hidden",
            ]
            [
                Html.input [
                    Attr.class "flex-1 items-center bg-transparent p-4",
                    Attr.placeholder "Search Genre, Actor, Director, ...",
                    Attr.disabled "true",
                ],
                Html.div
                    [
                        Attr.class "pr-4",

                    ]
                    [
                        Ui.IconButton.a {
                            icon: Ui.Icon.xMark {},
                            href: Feed.Route.encode (Feed),
                            target: "#app",
                        },
                    ],
            ],
    ]
