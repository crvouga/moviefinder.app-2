module [
    routeHx,
]

import Response
import pf.Task
import Feed.Controls.Route
import Ctx

routeHx : Ctx.Ctx, Feed.Controls.Route.Route -> Task.Task Response.Response _
routeHx = \_ctx, route ->
    when route is
        Controls ->
            Response.redirect (Feed Feed) |> Task.ok

        ControlsLoad ->
            Response.redirect (Feed Feed) |> Task.ok

        Unknown ->
            Response.redirect (Feed Feed) |> Task.ok
