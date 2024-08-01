module [Route, encode, decode, init]
import Auth.Login.Route
import Feed.Route

Route : [
    Index,
    RobotsTxt,
    Login Auth.Login.Route.Route,
    Feed Feed.Route.Route,
]

init : Route
init = Feed Feed

decode : Str -> Route
decode = \url ->
    paths = toPaths url
    head =
        paths
        |> List.first
        |> \first -> Result.withDefault first "/"

    when head is
        "/login" ->
            Login (Auth.Login.Route.decode url)

        "/feed" ->
            Feed (Feed.Route.decode url)

        "/robots.txt" ->
            RobotsTxt

        "/" ->
            Index

        _ ->
            Index

expect decode "/feed" == Feed Feed
expect decode "/login/verify-code" == Login VerifyCode

encode : Route -> Str
encode = \route ->
    when route is
        Login r ->
            Auth.Login.Route.encode r

        Feed r ->
            Feed.Route.encode r

        RobotsTxt ->
            "/robots"

        Index ->
            "/"

toPaths : Str -> List Str
toPaths = \url ->
    (Str.split url "/")
    |> \strs -> List.keepIf strs (\str -> str |> Str.isEmpty |> Bool.not)
    |> \strs -> List.map strs (\str -> Str.withPrefix str "/")

expect toPaths "/auth" == ["/auth"]
expect (toPaths "/auth/login/verify") == ["/auth", "/login", "/verify"]
