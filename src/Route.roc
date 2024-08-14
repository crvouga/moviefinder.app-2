module [Route, encode, decode, init]

import Url exposing [Url]
import Auth.Login.Route
import Feed.Route
import Account.Route
import Media.Details.Route

Route : [
    Index,
    RobotsTxt,
    Account Account.Route.Route,
    Login Auth.Login.Route.Route,
    Feed Feed.Route.Route,
    Media Media.Details.Route.Route,
]

init : Route
init = Feed Feed

decode : Url -> Route
decode = \url ->
    when Url.toPaths url is
        ["/login", ..] ->
            Login (Auth.Login.Route.decode url)

        ["/feed", ..] ->
            Feed (Feed.Route.decode url)

        ["/account", ..] ->
            Account (Account.Route.decode url)

        ["/media", ..] ->
            Media (Media.Details.Route.decode url)

        ["/robots.txt", ..] ->
            RobotsTxt

        ["/", ..] ->
            Index

        _ ->
            Index

encode : Route -> Url
encode = \route ->
    when route is
        Login r ->
            Auth.Login.Route.encode r

        Feed r ->
            Feed.Route.encode r

        Account r ->
            Account.Route.encode r

        Media r ->
            Media.Details.Route.encode r

        RobotsTxt ->
            Url.fromStr "/robots"

        Index ->
            Url.fromStr "/"
