module [
    routeHx,
]

import Html
import Html.Attr as Attr
import Ui.Button
# import Ui.TopBar as TopBar
import Response
import pf.Task
import Ctx
import Account.Route
import Route
import App.BottomNavigation as BottomNavigation

routeHx : Ctx.Ctx, Account.Route.Route -> Task.Task Response.Response _
routeHx = \ctx, route ->
    when route is
        Account ->
            queried =
                ctx.mediaDb.query! {
                    limit: 0,
                    offset: 10,
                    orderBy: Asc MediaId,
                    where: And [],
                }
            ctx.logger.info! (Inspect.toStr queried)
            view |> Response.html |> Task.ok

view : Html.Node
view =
    Html.div [Attr.class "w-full h-full flex flex-col"] [
        Html.div
            [
                Attr.class "w-full flex-1 flex items-center justify-center",
            ]
            [
                Ui.Button.view {
                    label: "Login",
                    href: Route.encode (Login SendCode),
                },
            ],
        BottomNavigation.view Account,
    ]
