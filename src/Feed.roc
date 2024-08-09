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
# import X
import Ui.Image
import App.Link
import Logger
import Feed.Form
# import pf.Sleep
# import Ui.SwiperFeed

defaultMediaQuery : {
    limit : U64,
    offset : U64,
}
defaultMediaQuery = {
    limit: 5,
    offset: 0,
}

routeHx : Ctx.Ctx, Feed.Route.Route -> Task.Task Response.Response _
routeHx = \ctx, route ->
    when route is
        Feed ->
            viewFeed |> Response.html |> Task.ok

        FeedItemsLoad mediaQuery ->
            queried =
                ctx.mediaDb.find! {
                    limit: mediaQuery.limit,
                    offset: mediaQuery.offset,
                    orderBy: Desc MediaId,
                    where: And [],
                }

            got <- ctx.keyValueStore.get "feed" |> Task.attempt

            Logger.info! ctx.logger (Inspect.toStr got)

            queried.rows |> viewFeedItems mediaQuery |> Response.html |> Response.hxTrigger "feedLoadedMoreItems" |> Task.ok

        Form r ->
            Feed.Form.routeHx ctx r

        Unknown ->
            Response.redirect (Feed Feed) |> Task.ok

viewChip : Str -> Html.Node
viewChip = \text ->
    Html.div
        [
            Attr.class "flex items-center justify-center px-2 py-1 bg-gray-200 rounded-full",
        ]
        [
            Html.span
                [
                    Attr.class "text-base font-bold text-gray-800",
                ]
                [Html.text text],
        ]

# jsRemoveFirstChildren : Str
# jsRemoveFirstChildren =
#     """
#     document.addEventListener('feedLoadedMoreItems', function () {
#         console.log('feedLoadedMoreItems');
#         const swiperElement = document.querySelector('swiper-container');
#         if(!swiperElement) {
#             return;
#         }
#         const swiper = swiperElement.swiper
#         const slideIndexes = []
#         for (let i = 0; i < 20; i++) {
#             slideIndexes.push(i);
#         }
#         console.log('slideIndexes', slideIndexes);
#         swiper.removeSlide(slideIndexes);
#     })
#     """

viewFeed : Html.Node
viewFeed =
    Html.div
        [
            Attr.class "w-full h-full flex flex-col",
            (Attr.attribute "hx-on") "htmx:afterSwap: console.log('swapped')",
        ]
        [
            Html.div
                [
                    Attr.class "w-full h-16 flex items-center justify-start px-4 border-b",
                ]
                [
                    viewChip "Popular",
                    # Ui.iconButton [] [
                    #     Ui.Icon.
                    # ],
                ],
            Html.div [Attr.class "w-full flex-1 overflow-hidden"] [
                # Html.script [Attr.type "module"] [Html.dangerouslyIncludeUnescapedHtml jsRemoveFirstChildren],
                Ui.Swiper.container
                    [
                        Attr.class "w-full max-w-full h-full max-h-full",
                        Ui.Swiper.slidesPerView 1,
                        Ui.Swiper.direction Vertical,
                    ]
                    [
                        Html.div
                            [
                                Attr.class "flex items-center justify-center w-full h-full",
                                Hx.swap OuterHtml,
                                Hx.trigger Load,
                                Hx.get (Feed.Route.encode (FeedItemsLoad defaultMediaQuery)),

                            ]
                            [
                                Ui.Spinner.view,
                            ],
                    ],
            ],
            App.BottomNavigation.view Home,
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
    Ui.Swiper.slide
        [
            Attr.class "w-full h-full flex flex-col items-center justify-center",
        ]
        [
            App.Link.view
                (Media (Details { mediaId: media.mediaId, mediaType: media.mediaType }))
                [
                    Attr.class "w-full h-full min-h-full flex-1 flex items-center justify-center",
                ]
                [
                    Ui.Image.view [
                        Attr.class "w-full h-full object-cover",
                        Attr.src (ImageSet.highestRes media.mediaPoster),
                    ],
                ],
        ]

viewFeedItemLoadMore : { limit : U64, offset : U64 } -> Html.Node
viewFeedItemLoadMore = \mediaQuery ->
    Ui.Swiper.slide
        [
            Attr.class "w-full h-full flex items-center justify-center",
            Hx.swap OuterHtml,
            Hx.trigger Intersect,
            Hx.get (Feed.Route.encode (FeedItemsLoad { mediaQuery & offset: mediaQuery.offset + mediaQuery.limit })),
        ]
        [
            Ui.Spinner.view,
        ]
