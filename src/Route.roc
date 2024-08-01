module [Route, encode, decode]
import Auth.Login.Route

Route : [
    Login Auth.Login.Route.Route,
    Home,
    RobotsTxt,
    Index,
    Unknown,
]

toPaths : Str -> List Str
toPaths = \url ->
    (Str.split url "/")
    |> \strs -> List.keepIf strs (\str -> str |> Str.isEmpty |> Bool.not)
    |> \strs -> List.map strs (\str -> Str.withPrefix str "/")

expect toPaths "/auth" == ["/auth"]
expect (toPaths "/auth/login/verify") == ["/auth", "/login", "/verify"]

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

        "/home" ->
            Home

        "/robots.txt" ->
            RobotsTxt

        "/" ->
            Index

        _ ->
            Unknown

expect decode "/home" == Home
expect decode "/foo" == Unknown
expect decode "/login/verify-code" == Login VerifyCode

encode : Route -> Str
encode = \route ->
    when route is
        Login r ->
            Auth.Login.Route.encode r

        Home ->
            "/home"

        RobotsTxt ->
            "/robots"

        Index ->
            "/"

        Unknown ->
            "/home"
