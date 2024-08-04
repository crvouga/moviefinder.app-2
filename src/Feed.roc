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
# import pf.Stdout
import Hx
import Ui.Spinner
import App.BottomNavigation
import ImageSet
import Ui.Swiper
import Ui.Image
import App.Link

defaultMediaQuery : {
    limit : U64,
    offset : U64,
}
defaultMediaQuery = {
    limit: 20,
    offset: 0,
}

routeHx : Ctx.Ctx, Feed.Route.Route -> Task.Task Response.Response _
routeHx = \ctx, route ->
    when route is
        Feed ->
            viewFeed |> Response.html |> Task.ok

        FeedItems mediaQuery ->
            queried =
                ctx.mediaDb.query! {
                    limit: mediaQuery.limit,
                    offset: mediaQuery.offset,
                    orderBy: Desc MediaId,
                    where: And [],
                }
            queried.rows |> viewFeedItems mediaQuery |> Response.html |> Task.ok

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
                        Hx.get (Feed.Route.encode (FeedItems defaultMediaQuery)),
                    ]
                    [
                        Ui.Spinner.view,
                    ],
            ],
        ],
        App.BottomNavigation.view Home,
    ]

viewFeedItemLoadMore : { limit : U64, offset : U64 } -> Html.Node
viewFeedItemLoadMore = \mediaQuery ->
    Ui.Swiper.slide
        [
            Attr.class "w-full h-full flex items-center justify-center",
            Hx.swap OuterHtml,
            Hx.trigger Intersect,
            Hx.get (Feed.Route.encode (FeedItems { mediaQuery & offset: mediaQuery.offset + mediaQuery.limit })),
        ]
        [
            Ui.Spinner.view,
        ]

viewFeedItems : List Media.Media, { limit : U64, offset : U64 } -> Html.Node
viewFeedItems = \mediaList, mediaQuery ->
    Html.fragment
        (
            List.concat
                (List.map mediaList viewFeedItem)
                (
                    if (List.len mediaList) > 0 then
                        [viewFeedItemLoadMore mediaQuery]
                    else
                        []
                )
        )

viewFeedItem : Media.Media -> Html.Node
viewFeedItem = \media ->
    Ui.Swiper.slide [] [
        App.Link.view
            (Media (Details { mediaId: media.mediaId, mediaType: media.mediaType }))
            []
            [
                Ui.Image.view [
                    Attr.class "w-full h-full object-cover",
                    Attr.src (ImageSet.highestRes media.mediaPoster),
                ],
            ],
    ]
