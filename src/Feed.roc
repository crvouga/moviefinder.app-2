module [
    routeHx,
]

import Html
import Html.Attr as Attr
import Response
import pf.Task
import Ctx
import Feed.Route
import Media
import App.BottomNavigation as BottomNavigation

routeHx : Ctx.Ctx, Feed.Route.Route -> Task.Task Response.Response _
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
            queried.rows |> viewFeed |> Response.html |> Task.ok

viewFeed : List Media.Media -> Html.Node
viewFeed = \mediaList ->
    Html.div [Attr.class "w-full h-full flex flex-col"] [
        # TopBar.view { title: "Feed" },
        Html.div [Attr.class "w-full flex-1 overflow-y-scroll"] [
            Html.div
                [Attr.class "flex flex-col w-full flex-1"]
                (List.map mediaList viewFeedItem),
        ],
        BottomNavigation.view Home,
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
