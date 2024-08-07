module [
    routeHx,
]

import Response
import pf.Task
import Ctx
import Html
import Html.Attr as Attr
import Media.Details.Route
import Media
import Ui.Image
import Hx
import MediaId exposing [MediaId]
import MediaType exposing [MediaType]
import Ui.Typography
import ImageSet
import Ui.Spinner
import X
import Ui.Button
import App.TopBar
import Ui.Icon
import MediaVideo

routeHx : Ctx.Ctx, Media.Details.Route.Route -> Task.Task Response.Response _
routeHx = \ctx, route ->
    when route is
        Details mediaQuery ->
            viewDetailsLoading mediaQuery |> Response.html |> Task.ok

        DetailsLoad mediaQuery ->
            queried <- ctx.mediaDb.findById mediaQuery.mediaId mediaQuery.mediaType |> Task.attempt

            when queried is
                Ok media ->
                    viewDetails media |> Response.html |> Task.ok

                Err NotFound ->
                    (Feed Feed) |> Response.redirect |> Task.ok

        Video mediaVideo ->
            mediaVideo |> viewEmbeddedVideo |> Response.html |> Task.ok

        Unknown ->
            (Feed Feed) |> Response.redirect |> Task.ok

viewDetailsLoading : { mediaId : MediaId, mediaType : MediaType } -> Html.Node
viewDetailsLoading = \mediaQuery -> Html.div
        [
            Attr.class "w-full h-full flex flex-col items-center justify-center",
            Hx.swap OuterHtml,
            Hx.trigger Load,
            Hx.get (Media.Details.Route.encode (DetailsLoad mediaQuery)),
        ]
        [
            App.TopBar.view {
                back: Feed Feed,
                title: "",
            },
            Ui.Image.view [
                Attr.src " ",
                Attr.alt " ",
                Attr.class "w-full aspect-video",
            ],
            Html.div
                [
                    Attr.class "w-full flex flex-1 flex-col items-center justify-start p-8",
                ]
                [
                    Ui.Spinner.view,
                ],
        ]

viewDetails : Media.Media -> Html.Node
viewDetails = \media ->
    Html.div
        [
            Attr.class "w-full h-full flex flex-col overflow-hidden",
        ]
        [
            App.TopBar.view {
                back: Feed Feed,
                title: media.mediaTitle,
            },
            Html.div
                [
                    Attr.class "w-full h-full flex flex-col overflow-hidden relative",
                    X.data jsData,
                ]
                [
                    viewVideoPlayers media,
                    Html.div
                        [
                            Attr.class "w-full h-full flex flex-col overflow-y-scroll",
                        ]
                        [
                            Ui.Image.view [
                                Attr.src (ImageSet.highestRes media.mediaBackdrop),
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
                                        text: media.mediaTitle,
                                        class: "text-center text-3xl font-bold",
                                    },
                                    Ui.Typography.view {
                                        variant: Body,
                                        text: media.mediaDescription,
                                        class: "text-center text-sm opacity-80",
                                    },
                                ],
                            viewVideoList media,
                        ],
                ],
        ]

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
            Ui.Spinner.view,
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
