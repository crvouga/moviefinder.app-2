module [
    routeHx,
]

import Html
import Html.Attr as Attr
import Ui.Button
import Ui.Icon as Icon
import Response
import pf.Task
import Ctx
import Account.Route
import Ui.Typography
import Route
import App.BottomNavigation as BottomNavigation

routeHx : Ctx.Ctx, Account.Route.Route -> Task.Task Response.Response _
routeHx = \_ctx, route ->
    when route is
        Account ->
            view |> Response.html |> Task.ok

view : Html.Node
view =
    Html.div [Attr.class "w-full h-full flex flex-col"] [
        Html.div
            [
                Attr.class "w-full flex-1 flex items-center justify-center flex-col gap-2",
            ]
            [
                Icon.doorOpen { class: "size-20" },
                Ui.Typography.view {
                    text: "Login to access your account",
                    class: "font-bold text-xl",
                    variant: H2,
                },
                Ui.Button.a {
                    label: "Login",
                    href: Route.encode (Login SendCode),
                    target: "#app",
                },
            ],
        BottomNavigation.view Account,
    ]
