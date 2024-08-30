module [
    routeHx,
]

import Response
import pf.Task
import Ctx
import Html
import Html.Attr as Attr
import Media.Details.Route exposing [DetailsQuery, Route]
import Media
import Ui.Image
import Hx
import Ui.Typography
import ImageSet
import Ui.Spinner
import X
import Ui.Button
import App.TopBar
import Ui.Icon
import MediaVideo

routeHx : Ctx.Ctx, Route -> Task.Task Response.Response _
routeHx = \ctx, route ->
    when route is
        Details mediaQuery ->
            Loading mediaQuery |> viewDetails |> Response.html |> Task.ok

        DetailsLoad mediaQuery ->
            queried <- ctx.mediaDb.findById mediaQuery.mediaId mediaQuery.mediaType |> Task.attempt

            when queried is
                Ok media ->
                    Loaded media |> viewDetails |> Response.html |> Task.ok

                Err NotFound ->
                    (Feed Feed) |> Response.redirect |> Task.ok

        Video mediaVideo ->
            mediaVideo |> viewEmbeddedVideo |> Response.html |> Task.ok

        Unknown ->
            (Feed Feed) |> Response.redirect |> Task.ok

Details : [Loading DetailsQuery, Loaded Media.Media]

viewDetails : Details -> Html.Node
viewDetails = \details ->
    Html.div
        (
            List.concat
                [
                    Attr.class "w-full h-full flex flex-col overflow-hidden",
                ]
                (toDetailsAttrs details)
        )
        [
            App.TopBar.view {
                back: Feed Feed,
                title: toPageTitle details,
            },
            Html.div
                [
                    Attr.class "w-full h-full flex flex-col overflow-hidden relative",
                    X.data jsData,
                ]
                [
                    viewDetailsVideoPlayers details,
                    Html.div
                        [
                            Attr.class "w-full h-full flex flex-col overflow-y-scroll",
                        ]
                        [
                            Ui.Image.view [
                                Attr.src (viewDetailsImageSrc details),
                                Attr.alt " ",
                                Attr.class "w-full aspect-video shrink-0",
                            ],
                            Html.div
                                [
                                    Attr.class "w-full p-4 gap-4 flex flex-col",
                                ]
                                [
                                    Ui.Typography.view {
                                        variant: H1,
                                        text: toTitle details,
                                        class: "text-center text-3xl font-bold",
                                        skeleton: skeleton details,
                                    },
                                    Ui.Typography.view {
                                        variant: Body,
                                        text: toDescription details,
                                        class: "text-center text-sm opacity-80",
                                        skeleton: skeleton details,
                                    },
                                ],
                            viewDetailsVideoList details,
                        ],
                ],
        ]

skeleton : Details -> Bool
skeleton = \details ->
    when details is
        Loading _ -> Bool.true
        Loaded _ -> Bool.false

toDetailsAttrs : Details -> List Attr.Attribute
toDetailsAttrs = \details ->
    when details is
        Loading mediaQuery ->
            [
                Hx.swap OuterHtml,
                Hx.trigger Load,
                Hx.get (Media.Details.Route.encode (DetailsLoad mediaQuery)),
            ]

        Loaded _ ->
            []

viewDetailsImageSrc : Details -> Str
viewDetailsImageSrc = \details ->
    when details is
        Loaded media -> ImageSet.highestRes media.mediaBackdrop
        Loading _ -> ""

viewDetailsVideoList : Details -> Html.Node
viewDetailsVideoList = \details ->
    when details is
        Loaded media -> viewVideoList media
        Loading _ -> Html.fragment []

toPageTitle : Details -> Str
toPageTitle = \details ->
    when details is
        Loaded media -> media.mediaTitle
        Loading _ -> ""

toTitle : Details -> Str
toTitle = \details ->
    when details is
        Loaded media -> media.mediaTitle
        Loading query -> Str.repeat "a " (query.titleLen // 2)

toDescription : Details -> Str
toDescription = \details ->
    when details is
        Loaded media -> media.mediaDescription
        Loading query -> Str.repeat "a " (query.descriptionLen // 2)

viewDetailsVideoPlayers : Details -> Html.Node
viewDetailsVideoPlayers = \details ->
    when details is
        Loaded media -> viewVideoPlayers media
        Loading _ -> Html.fragment []

jsRefVideoIframeId : MediaVideo.MediaVideo -> Str
jsRefVideoIframeId = \video ->
    "iframe-$(video.youtubeId)"

jsEffectPlayPauseVideo : MediaVideo.MediaVideo -> Str
jsEffectPlayPauseVideo = \video ->
    """
    const iframe = $refs['$(jsRefVideoIframeId video)'];
    if(iframe && videoYoutubeId === '$(video.youtubeId)') {
        iframe.contentWindow.postMessage(JSON.stringify({ event: 'command', func: 'playVideo', args: '' }), '*');
    } else if(iframe) {
        iframe.contentWindow.postMessage(JSON.stringify({ event: 'command', func: 'pauseVideo', args: '' }), '*');
    }
    """

viewEmbeddedVideo : MediaVideo.MediaVideo -> Html.Node
viewEmbeddedVideo = \mediaVideo -> Html.div
        [
            Attr.class "w-full h-full flex items-center justify-center",
        ]
        [
            Html.iframe
                [
                    Attr.src mediaVideo.youtubeEmbedUrl,
                    X.ref (jsRefVideoIframeId mediaVideo),
                    X.effect (jsEffectPlayPauseVideo mediaVideo),
                    Attr.class "w-full h-full",
                    (Attr.attribute "frameborder") "0",
                    Attr.allow "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture",
                    (Attr.attribute "allowfullscreen") "true",
                ]
                [],
        ]

jsIsVideoVisible : MediaVideo.MediaVideo -> Str
jsIsVideoVisible = \video ->
    "videoYoutubeId === '$(video.youtubeId)'"

jsData : Str
jsData = "{ videoYoutubeId: null, timeoutsByYoutubeId: {} }"

jsToggleVideo : MediaVideo.MediaVideo -> Str
jsToggleVideo = \video ->
    "videoYoutubeId = $(jsIsVideoVisible video) ? null : '$(video.youtubeId)'"

viewVideoPlayers : Media.Media -> Html.Node
viewVideoPlayers = \media ->
    Html.fragment (List.map media.mediaVideos viewVideoPlayer)

viewVideoPlayer : MediaVideo.MediaVideo -> Html.Node
viewVideoPlayer = \mediaVideo ->
    Html.div
        [
            Attr.class "absolute top-0 left-0 w-full z-10 pointer-events-none",
            X.show (jsIsVideoVisible mediaVideo),
        ]
        [
            Html.div [Attr.class "aspect-video w-full bg-black border-b pointer-events-auto"] [
                viewLoadVideoPlayer mediaVideo,
            ],
            Html.div
                [
                    Attr.class "w-full p-3 flex items-center justify-end",
                ]
                [
                    Ui.Button.button
                        [
                            X.on Click (jsToggleVideo mediaVideo),
                        ]
                        {
                            label: "Close",
                            class: "pointer-events-auto",
                        },
                ],
        ]

viewLoadVideoPlayer : MediaVideo.MediaVideo -> Html.Node
viewLoadVideoPlayer = \mediaVideo ->
    Html.div
        [
            Attr.class "w-full h-full flex items-center justify-center",
            Hx.swap OuterHtml,
            Hx.trigger Intersect,
            Hx.get (Media.Details.Route.encode (Video mediaVideo)),
        ]
        [
            Ui.Spinner.view {},
        ]

viewVideoList : Media.Media -> Html.Node
viewVideoList = \media ->
    if List.len media.mediaVideos == 0 then
        Html.fragment []
    else
        Html.div
            [
                Attr.class "w-full h-full flex flex-col",
            ]
            [
                Ui.Typography.view {
                    variant: H2,
                    text: "Videos",
                    class: "text-3xl font-bold p-4",
                },
                Html.div [] (List.map media.mediaVideos viewVideoListItem),
            ]

viewVideoListItem : MediaVideo.MediaVideo -> Html.Node
viewVideoListItem = \mediaVideo -> Html.button
        [
            Attr.class "w-full flex items-center justify-center",
            X.on Click (jsToggleVideo mediaVideo),
        ]
        [
            Html.div
                [
                    Attr.class "aspect-video w-32 overflow-hidden",
                ]
                [
                    Ui.Image.view [
                        Attr.src (ImageSet.highestRes mediaVideo.thumbnail),
                        Attr.alt " ",
                        Attr.class "w-full h-full object-cover",
                    ],
                ],
            Html.div
                [
                    Attr.class "flex-1 p-4 gap-4 flex flex-row items-center truncate",
                ]
                [
                    Ui.Typography.view {
                        variant: Body,
                        text: mediaVideo.name,
                        class: "text-left flex-1 text-sm opacity-80 truncate",
                    },
                    Html.div
                        [
                            X.show (jsIsVideoVisible mediaVideo),
                        ]
                        [
                            Ui.Icon.checkmark {
                                class: "shrink-0 size-8",
                            },
                        ],
                ],
        ]
