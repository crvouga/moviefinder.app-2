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
# import Ui.Topbar
import ImageSet
import Ui.Spinner
import MediaVideo

routeHx : Ctx.Ctx, Media.Details.Route.Route -> Task.Task Response.Response _
routeHx = \ctx, route ->
    when route is
        Details mediaQuery ->
            viewDetailsLoading mediaQuery |> Response.html |> Task.ok

        DetailsLoad mediaQuery ->
            queried <- (ctx.mediaDb.findById mediaQuery.mediaId mediaQuery.mediaType) |> Task.attempt

            # ctx.logger.info! (Inspect.toStr queried)

            when queried is
                Ok media ->
                    viewDetails media |> Response.html |> Task.ok

                Err NotFound ->
                    (Feed Feed) |> Response.redirect |> Task.ok

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
            Ui.Spinner.view,
        ]

viewDetails : Media.Media -> Html.Node
viewDetails = \media -> Html.div
        [
            Attr.class "w-full h-full flex flex-col overflow-y-scroll",
        ]
        [
            # Ui.Topbar.view { title: media.mediaTitle },
            Ui.Image.view [
                Attr.src (ImageSet.highestRes media.mediaBackdrop),
                Attr.alt " ",
                Attr.class "w-full aspect-video",
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
            viewMediaVideos media,
        ]

viewMediaVideos : Media.Media -> Html.Node
viewMediaVideos = \media -> Html.div
        [
            Attr.class "w-full h-full flex flex-col",
        ]
        [
            Ui.Typography.view {
                variant: H2,
                text: "Videos",
                class: "text-3xl font-bold p-4",
            },
            Html.div [] (List.map media.mediaVideos viewMediaVideo),
        ]

viewMediaVideo : MediaVideo.MediaVideo -> Html.Node
viewMediaVideo = \mediaVideo -> Html.button
        [
            Attr.class "w-full flex items-center justify-center",
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
                    Attr.class "flex-1 p-4 gap-4 flex flex-col truncate",
                ]
                [
                    Ui.Typography.view {
                        variant: Body,
                        text: mediaVideo.name,
                        class: "text-center text-sm opacity-80 truncate",
                    },
                ],
        ]
