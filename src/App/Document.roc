module [view]

import Html
import Html.Attr as Attr
import Hx
import Ui.Spinner
import Route
import App.Styles
import "../Ui/image-element.js" as imageElementJs : Str

view : { route : Route.Route } -> Html.Node
view = \{ route } ->
    Html.html [Attr.lang "en"] [
        Html.head
            []
            [
                Html.title [] [Html.text "moviefinder.app"],
                Html.meta [Attr.charset "UTF-8"],
                Html.meta [Attr.name "viewport", Attr.content "width=device-width, initial-scale=1.0"],
                Html.meta [Attr.name "description", Attr.content "Find movies and TV shows to watch."],
                Html.meta [Attr.name "theme-color", Attr.content "#000000"],
                Html.link [Attr.rel "icon", Attr.href "data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 36 36'><text y='32' font-size='32'>🍿</text></svg>"],
                Html.script [Attr.src "https://cdn.tailwindcss.com"] [],
                Html.script [Attr.src "https://unpkg.com/htmx.org@2.0.1", Attr.defer "true"] [],
                Html.script [Attr.src "https://cdn.jsdelivr.net/npm/swiper@11/swiper-element-bundle.min.js", Attr.defer "true"] [],
                Html.script [] [Html.text imageElementJs],
                App.Styles.view,
            ],
        Html.body
            [
                Attr.class "bg-black text-white flex flex-col items-center justify-center w-full h-[100dvh] max-h-[100dvh]",
            ]
            [
                Html.div
                    [
                        Attr.class "w-full max-w-[500px] h-full max-h-[800px] border rounded overflow-hidden",
                        Attr.id "app",
                        Hx.boost Bool.true,
                    ]
                    [
                        Html.div
                            [
                                Attr.class "flex items-center justify-center w-full h-full",
                                Hx.swap OuterHtml,
                                Hx.trigger Load,
                                Hx.get (Route.encode route),
                            ]
                            [
                                Ui.Spinner.view,
                            ],
                    ],
            ],
    ]
