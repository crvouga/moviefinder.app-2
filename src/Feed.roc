module [
    routeHx,
    viewLoadPrev,
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
import Ui.Icon
import Ui.IconButton
import Url
import Feed.Controls
import Feed.Feed exposing [Feed]
# import pf.Sleep
# import Pagination
# import X

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

        LoadNext ->
            got <- ctx.feedDb.get "some-feed-id" |> Task.attempt

            fallback : Feed
            fallback = {
                feedId: "some-feed-id",
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
            |> viewFeedItems
            |> Response.html
            |> Task.ok

        LoadPrev ->
            got <- ctx.feedDb.get "some-feed-id" |> Task.attempt

            fallback : Feed
            fallback = {
                feedId: "some-feed-id",
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
            |> viewFeedItems
            |> Response.html
            |> Task.ok

        Controls r ->
            Feed.Controls.routeHx ctx r

        ChangedSlide payload ->
            got <- ctx.feedDb.get "some-feed-id" |> Task.attempt

            fallback : Feed
            fallback = {
                feedId: "some-feed-id",
                activeIndex: payload.index - 1,
            }

            feed = got |> Result.withDefault fallback

            feedNext = { feed & activeIndex: payload.index }
            Logger.info! ctx.logger (Inspect.toStr got)

            put <- ctx.feedDb.put feedNext |> Task.attempt

            Logger.info! ctx.logger (Inspect.toStr put)

            Response.nothing |> Task.ok

        Unknown url ->
            Logger.info! ctx.logger (Inspect.toStr (Url.toPaths (Url.fromStr url)))
            Response.redirect (Feed Feed) |> Task.ok

viewChip : Str -> Html.Node
viewChip = \text ->
    Html.div
        [
            Attr.class "flex items-center justify-center px-3 py-1 bg-gray-200 rounded-full w-fit",
        ]
        [
            Html.span
                [
                    Attr.class "text-base font-bold text-gray-800",
                ]
                [Html.text text],
        ]

changeSlideEndpoint : Str
changeSlideEndpoint = (ChangedSlide { index: 0 }) |> Feed.Route.encode |> Url.toStr

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
        const endpointTemplate = '$(changeSlideEndpoint)'
        const endpoint = endpointTemplate.replace('0', feedIndex)
        htmx.ajax('POST', endpoint, { swap: 'none' })
        window.history.pushState({}, '', `/feed?activeIndex=${feedIndex}`)
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
                    Html.div
                        [
                            Attr.class "flex-1 items-center",
                        ]
                        [
                            viewChip "Popular",
                        ],
                    Ui.IconButton.a {
                        icon: Ui.Icon.adjustmentsHorizontal {},
                        href: Feed.Route.encode (Controls Controls),
                        target: "#app",
                        label: "Controls",
                    },
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
                                Hx.get (Feed.Route.encode LoadNext),

                            ]
                            [
                                Ui.Spinner.view {},
                            ],
                    ],
            ],
            App.BottomNavigation.view Home,
        ]

viewFeedItems : List FeedItem -> Html.Node
viewFeedItems = \feedItems ->
    Html.fragment
        (
            []
            |> List.concat (List.map feedItems viewFeedItem)
            |> List.concat
                (
                    if (List.len feedItems) > 0 then
                        [viewLoadNext]
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
                {
                    route: Media
                        (
                            Details {
                                mediaId: feedItem.media.mediaId,
                                mediaType: feedItem.media.mediaType,
                                titleLen: feedItem.media.mediaTitle |> Str.toUtf8 |> List.len,
                                descriptionLen: feedItem.media.mediaDescription |> Str.toUtf8 |> List.len,
                            }
                        ),
                    label: "View details",
                    attrs: [
                        Attr.class "w-full h-full min-h-full flex-1 flex items-center justify-center relative",
                    ],
                }
                [
                    Html.div
                        [
                            Attr.class "w-full h-full",
                            Hx.loadingClassAdd "opacity-50",
                        ]
                        [
                            Ui.Image.view [
                                Attr.class "w-full h-full object-cover",
                                Attr.src (ImageSet.highestRes feedItem.media.mediaPoster),

                            ],
                        ],
                    Html.div
                        [
                            Attr.class "absolute inset-0 pointer-events-none flex items-center justify-center opacity-0",
                            Hx.loadingClassRemove "opacity-0",
                        ]
                        [
                            Ui.Spinner.view {},
                        ],
                ],
        ]

viewLoadPrev : Html.Node
viewLoadPrev =
    Ui.Swiper.slide
        [
            Attr.class "w-full h-full flex items-center justify-center",
            Hx.swap OuterHtml,
            Hx.trigger Intersect,
            Hx.get (Feed.Route.encode LoadPrev),
        ]
        [
            Ui.Spinner.view {},
        ]

viewLoadNext : Html.Node
viewLoadNext =
    Ui.Swiper.slide
        [
            Attr.class "w-full h-full flex items-center justify-center",
            Hx.swap OuterHtml,
            Hx.trigger Intersect,
            Hx.get (Feed.Route.encode LoadNext),
        ]
        [
            Ui.Spinner.view {},
        ]
