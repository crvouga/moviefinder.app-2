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
import Hx
import Ui.Spinner
import App.BottomNavigation
import ImageSet
import Ui.Swiper

routeHx : Ctx.Ctx, Feed.Route.Route -> Task.Task Response.Response _
routeHx = \ctx, route ->
    when route is
        Feed ->
            viewFeed |> Response.html |> Task.ok

        FeedItems ->
            queried =
                ctx.mediaDb.query! {
                    limit: 0,
                    offset: 10,
                    orderBy: Asc MediaId,
                    where: And [],
                }
            queried.rows |> viewFeedItems |> Response.html |> Task.ok

viewFeed : Html.Node
viewFeed =
    Html.div [Attr.class "w-full h-full flex flex-col"] [
        Html.div [Attr.class "w-full flex-1 overflow-hidden"] [
            Ui.Swiper.container { classList: ["h-full"] } [
                Html.div
                    [
                        Attr.class "flex items-center justify-center w-full h-full",
                        Hx.swap OuterHtml,
                        Hx.trigger Load,
                        Hx.get (Feed.Route.encode FeedItems),
                    ]
                    [
                        Ui.Spinner.view,
                    ],
            ],
        ],
        App.BottomNavigation.view Home,
    ]

viewFeedItemLoadMore : Html.Node
viewFeedItemLoadMore =
    Ui.Swiper.slide
        [
            Attr.class "w-full h-full flex items-center justify-center",
            Hx.swap OuterHtml,
            Hx.trigger Intersect,
            Hx.get (Feed.Route.encode FeedItems),
        ]
        [
            Ui.Spinner.view,
        ]

viewFeedItems : List Media.Media -> Html.Node
viewFeedItems = \mediaList ->
    Html.fragment
        (List.concat (List.map mediaList viewFeedItem) [viewFeedItemLoadMore])

viewFeedItem : Media.Media -> Html.Node
viewFeedItem = \media ->
    Ui.Swiper.slide [] [
        Html.img [
            Attr.class "w-full h-full object-cover",
            Attr.src (ImageSet.highestRes media.mediaPoster),
        ],
    ]
