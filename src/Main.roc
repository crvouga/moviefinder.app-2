app [Model, server] {
    pf: platform "https://github.com/roc-lang/basic-webserver/releases/download/0.9.0/taU2jQuBf-wB8EJb0hAkrYLYOGacUU5Y9reiHG45IY4.tar.br",
    json: "https://github.com/lukewilliamboswell/roc-json/releases/download/0.10.0/KbIfTNbxShRX1A1FgXei1SpO5Jn8sgP6HP6PXbi-xyA.tar.br",
    base64: "https://github.com/adomurad/roc-base64/releases/download/v0.2.0/hdowh25hurV_dACKR6IMJs-Up3hgAiokhYtRRNSn88k.tar.br",

}

import pf.Http
import pf.Env
import Request
import Response
import Auth.Router
import Hx
import Ctx
import Ctx.Impl
import Route
import Account.Router
import Feed.Router
import App.Document
import Logger
import Media.Details.Router

Model : {}

server = { init: Task.ok {}, respond }

respond : Http.Request, Model -> Task Http.Response [ServerErr Str]_
respond = \httpReq, _ ->
    tmdbApiReadAccessToken <- Env.var "TMDB_API_READ_ACCESS_TOKEN" |> Task.onErr (\_ -> Task.ok "") |> Task.await
    databaseUrl <- Env.var "DATABASE_URL" |> Task.onErr (\_ -> Task.ok "") |> Task.await

    req = Request.fromHttp httpReq

    ctx = Ctx.Impl.init { tmdbApiReadAccessToken, databaseUrl, req }
    Logger.info! ctx.logger (Inspect.toStr req)

    res =
        if
            Hx.isReq httpReq
        then
            routeHx ctx req
        else
            routeReq req
    res |> Task.map Response.toHttp

routeHx : Ctx.Ctx, Request.Request -> Task.Task Response.Response _
routeHx = \ctx, req ->
    when req.route is
        Login r ->
            Auth.Router.routeHx ctx r

        Feed r ->
            Feed.Router.routeHx ctx r

        Account r ->
            Account.Router.routeHx ctx r

        Media r ->
            Media.Details.Router.routeHx ctx r

        Index | RobotsTxt ->
            Route.init |> Response.redirect |> Task.ok

routeReq : Request.Request -> Task.Task Response.Response _
routeReq = \req ->
    when req.route is
        RobotsTxt ->
            robotsTxt : Str
            robotsTxt =
                """
                User-agent: *
                Allow: /
                """
            Response.text robotsTxt |> Task.ok

        _ ->
            route : Route.Route
            route =
                when req.route is
                    Index -> Route.init
                    _ -> req.route

            App.Document.view { route }
            |> Response.html
            |> Task.ok

