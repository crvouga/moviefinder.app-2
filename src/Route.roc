module [Route, encode, decode, init]

import Auth.Login.Route
import Feed.Route
import Account.Route
import Url exposing [Url]

Route : [
    Index,
    RobotsTxt,
    Account Account.Route.Route,
    Login Auth.Login.Route.Route,
    Feed Feed.Route.Route,
]

init : Route
init = Feed Feed

decode : Url -> Route
decode = \url ->
    head =
        url
        |> toPaths
        |> List.first
        |> \first -> Result.withDefault first "/"

    when head is
        "/login" ->
            Login (Auth.Login.Route.decode url)

        "/feed" ->
            Feed (Feed.Route.decode url)

        "/account" ->
            Account (Account.Route.decode url)

        "/robots.txt" ->
            RobotsTxt

        "/" ->
            Index

        _ ->
            Index

expect decode (Url.fromStr "/feed") == Feed Feed
expect decode (Url.fromStr "/login/verify-code") == Login VerifyCode

encode : Route -> Url
encode = \route ->
    when route is
        Login r ->
            Auth.Login.Route.encode r

        Feed r ->
            Feed.Route.encode r

        Account r ->
            Account.Route.encode r

        RobotsTxt ->
            Url.fromStr "/robots"

        Index ->
            Url.fromStr "/"

toPaths : Url -> List Str
toPaths = \url ->
    Url.toStr url
    |> Str.split "/"
    |> List.keepIf (\s -> s |> Str.isEmpty |> Bool.not)
    |> List.map (\s -> s |> Str.withPrefix "/")

expect (toPaths (Url.fromStr "/auth")) == ["/auth"]
expect (toPaths (Url.fromStr "/auth/login/verify")) == ["/auth", "/login", "/verify"]
