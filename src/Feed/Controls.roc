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
import Media.Genre exposing [Genre]
import pf.Task

routeHx : Ctx.Ctx, Feed.Controls.Route.Route -> Task.Task Response.Response _
routeHx = \ctx, route ->
    when route is
        Controls ->
            allGenres <- ctx.genreDb.all {} |> Task.attempt

            when allGenres is
                Err _ -> viewControlsErr |> Response.html |> Task.ok
                Ok genres -> viewControls genres |> Response.html |> Task.ok

        ControlsLoad ->
            Response.redirect (Feed Feed) |> Task.ok

        Unknown ->
            Response.redirect (Feed Feed) |> Task.ok

viewTopBar : Html.Node
viewTopBar =
    Html.div
        [
            Attr.class "w-full h-16 flex items-center justify-start overflow-hidden",
        ]
        [
            Html.div [] [],
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
        ]

viewControlsErr : Html.Node
viewControlsErr =
    Html.div [] [
        viewTopBar,
        Html.div [] [
            Html.text "errored",
        ],
    ]

viewControls : List Genre -> Html.Node
viewControls = \genres ->
    Html.div [] [
        viewTopBar,
        Html.fragment (List.map genres \genre -> Html.text genre.genreName),
    ]
