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
import Logger
import Url
import Feed.Form
import Feed.Feed exposing [Feed]
# import pf.Sleep
# import Pagination
# import X

defaultMediaQuery : {
    limit : U64,
    offset : U64,
}
defaultMediaQuery = {
    limit: 5,
    offset: 0,
}

FeedItem : {
    index : U64,
    media : Media.Media,
}

limit = 10

routeHx : Ctx.Ctx, Feed.Route.Route -> Task.Task Response.Response _
routeHx = \ctx, route ->
    when route is
        Feed ->
            viewFeed |> Response.html |> Task.ok

        FeedItemsLoad mediaQuery ->
            got <- ctx.feedDb.get "feed" |> Task.attempt

            fallback : Feed
            fallback = {
                feedId: "feed",
                activeIndex: 0,
            }

            feed = got |> Result.withDefault fallback
            #
            Logger.info! ctx.logger (Inspect.toStr feed)

            queried =
                ctx.mediaDb.find! {
                    limit,
                    offset: feed.activeIndex,
                    orderBy: Desc MediaId,
                    where: And [],
                }
            Logger.info! ctx.logger (Inspect.toStr feed)

            feedItems =
                queried.rows
                |> List.mapWithIndex (\media, indexWithinPage -> { media, index: indexWithinPage + feed.activeIndex })

            feedItems
            |> viewFeedItems mediaQuery
            |> Response.html
            |> Task.ok

        Form r ->
            Feed.Form.routeHx ctx r

        ChangedSlide payload ->
            got <- ctx.feedDb.get "feed" |> Task.attempt

            fallback : Feed
            fallback = {
                feedId: "feed",
                activeIndex: payload.index - 1,
            }

            feed = got |> Result.withDefault fallback

            feedNext : Feed
            feedNext = { feed & activeIndex: payload.index }
            Logger.info! ctx.logger (Inspect.toStr got)

            put <- ctx.feedDb.put feedNext |> Task.attempt

            Logger.info! ctx.logger (Inspect.toStr put)

            Html.fragment [] |> Response.html |> Task.ok

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

jsWatchSlideChange : Str
jsWatchSlideChange =
    """
    swiperEl = document.querySelector('swiper-container')
    swiperEl.addEventListener('swiperslidechange', (e) => {
        const swiper = e.detail[0]
        const activeIndex = swiper.activeIndex
        const activeSlide = swiper.slides[activeIndex]
        const feedIndex = parseInt(activeSlide.getAttribute('data-feed-index'), 10)
        if(typeof feedIndex !== 'number' || Number.isNaN(feedIndex)) {
            return
        }
        const endpointTemplate = "$((ChangedSlide { index: 0 }) |> Feed.Route.encode |> Url.toStr)"
        const endpoint = endpointTemplate.replace("0", feedIndex)
        htmx.ajax('POST', endpoint, { swap: 'none' })
    })
    """

viewFeed : Html.Node
viewFeed =
    Html.div
        [
            Attr.class "w-full h-full flex flex-col overflow-hidden",
        ]
        [
            Html.div
                [
                    Attr.class "w-full h-16 flex items-center justify-start px-4 border-b overflow-hidden",
                ]
                [
                    viewChip "Popular",
                    # Ui.iconButton [] [
                    #     Ui.Icon.
                    # ],
                ],
            Html.script [] [Html.dangerouslyIncludeUnescapedHtml jsWatchSlideChange],
            Html.div [Attr.class "w-full flex-1 overflow-hidden"] [
                Ui.Swiper.container
                    [
                        Attr.class "w-full max-w-full h-full max-h-full",
                        Ui.Swiper.slidesPerView 1,
                        Ui.Swiper.direction Vertical,
                        Ui.Swiper.speed 300,
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
                                Ui.Spinner.view {},
                            ],
                    ],
            ],
            App.BottomNavigation.view Home,
        ]

viewFeedItems : List FeedItem, { limit : U64, offset : U64 } -> Html.Node
viewFeedItems = \feedItems, mediaQuery ->
    Html.fragment
        (
            List.concat
                (List.map feedItems viewFeedItem)
                (
                    if (List.len feedItems) > 0 then
                        [viewFeedItemLoadMore mediaQuery]
                    else
                        []
                )
        )

viewFeedItem : FeedItem -> Html.Node
viewFeedItem = \feedItem ->
    Ui.Swiper.slide
        [
            Attr.class "w-full h-full flex flex-col items-center justify-center",
            (Attr.attribute "data-feed-index") (Num.toStr feedItem.index),
        ]
        [
            App.Link.view
                (Media (Details { mediaId: feedItem.media.mediaId, mediaType: feedItem.media.mediaType }))
                [
                    Attr.class "w-full h-full min-h-full flex-1 flex items-center justify-center",
                ]
                [
                    Ui.Image.view [
                        Attr.class "w-full h-full object-cover",
                        Attr.src (ImageSet.highestRes feedItem.media.mediaPoster),
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
            Ui.Spinner.view {},
        ]
