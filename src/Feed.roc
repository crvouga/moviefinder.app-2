module [
    routeHx,
]

import Html
import Html.Attr as Attr
import Ui.Button as Button
import Ui.TopBar as TopBar
import Response
import pf.Task
import Ctx
import Feed.Route
import Media

routeHx : Ctx.Ctx, Feed.Route.Route -> Task.Task Response.Response []
routeHx = \ctx, route ->
    when route is
        Feed ->
            queried =
                ctx.mediaDb.query! {
                    limit: 0,
                    offset: 10,
                    orderBy: Asc MediaId,
                    where: And [],
                }
            ctx.logger.info! (Inspect.toStr queried)
            queried.rows |> viewFeed |> Response.html |> Task.ok

viewFeed : List Media.Media -> Html.Node
viewFeed = \mediaList ->
    Html.div [Attr.class "w-full h-full flex flex-col"] [
        TopBar.view { title: "Feed" },
        Html.div
            [Attr.class "flex flex-col w-full p-4 gap-8"]
            [Button.view { label: "Account", href: "/login" }],
        Html.div
            [Attr.class "flex flex-col w-full flex-1"]
            (List.map mediaList viewFeedItem),
    ]

viewFeedItem : Media.Media -> Html.Node
viewFeedItem = \media ->
    Html.div
        [
            Attr.class "w-full p-4",
        ]
        [
            Html.text media.mediaTitle,
        ]
