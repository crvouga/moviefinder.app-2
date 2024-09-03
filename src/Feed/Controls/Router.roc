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
import Ui.Chip
import pf.Task
import Feed.Controls.Item as Item exposing [Item]
import Hx

routeHx : Ctx.Ctx, Feed.Controls.Route.Route -> Task.Task Response.Response _
routeHx = \ctx, route ->
    when route is
        Controls _ ->
            allGenres <- ctx.genreDb.all {} |> Task.attempt

            when allGenres is
                Err _ -> viewControlsErr |> Response.html |> Task.ok
                Ok genres ->
                    items : List Item
                    items = List.map genres ItemGenre
                    viewControls items |> Response.html |> Task.ok

        ControlsLoad ->
            Response.redirect (Feed Feed) |> Task.ok

        ClickedChip item ->
            when item is
                ItemGenre _ ->
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
                    Attr.class "px-2 w-full flex items-center justify-center",
                ]
                [
                    Html.div [Attr.class "flex-1"] [],
                    Ui.IconButton.a {
                        icon: Ui.Icon.xMark {},
                        href: Feed.Route.encode (Feed),
                        target: "#app",
                        label: "Close",
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

viewControls : List Item -> Html.Node
viewControls = \items ->
    Html.div [] [
        viewTopBar,
        Html.div
            [Attr.class "flex gap-2 flex-wrap items-center justify-start p-4"]
            (
                List.map items \item -> Ui.Chip.view
                        {
                            label: Item.chipLabel item,
                            selected: Bool.true,

                        }
                        [Hx.post (Feed.Controls.Route.encode (ClickedChip item))]
            ),
    ]
