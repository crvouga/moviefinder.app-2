module [
    routeHx,
]

import Response
import pf.Task
import Feed.Form.Route
import Ctx

routeHx : Ctx.Ctx, Feed.Form.Route.Route -> Task.Task Response.Response _
routeHx = \_ctx, route ->
    when route is
        Form ->
            Response.redirect (Feed Feed) |> Task.ok

        FormLoad ->
            Response.redirect (Feed Feed) |> Task.ok

        Unknown ->
            Response.redirect (Feed Feed) |> Task.ok
