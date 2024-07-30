module [routeHx]

import pf.Task
import pf.Http
import pf.Sleep
import Response
import Html.Html as Html
import Html.Attr as Attr
import Ui.TopBar as TopBar
import Ui.TextField as TextField
import Ui.Button as Button
import Ui.Typography as Typography

Route : [SendCode, SentCode, VerifyCode, VerifiedCode, Unknown]

strToRoute : Str -> Route
strToRoute = \str ->
    when str is
        "/login" -> SendCode
        "/login/send-code" -> SentCode
        "/login/verify-code" -> VerifyCode
        "/login/verified-code" -> VerifiedCode
        _ -> Unknown

routeToStr : Route -> Str
routeToStr = \route ->
    when route is
        SendCode -> "/login"
        SentCode -> "/login/send-code"
        VerifyCode -> "/login/verify-code"
        VerifiedCode -> "/login/verified-code"
        Unknown -> "/"

viewSendCode : Html.Node
viewSendCode = Html.div
    [
        Attr.class "w-full h-full flex flex-col",
    ]
    [
        TopBar.view { title: "Login with phone" },
        Html.div
            [
                Attr.class "flex flex-col w-full flex-1 p-4 gap-8",
            ]
            [
                TextField.view { label: "Phone number" },
                Button.view { label: "Send code", href: routeToStr SendCode },
            ],
    ]

viewVerifyCode : Html.Node
viewVerifyCode = Html.div
    [
        Attr.class "w-full h-full flex flex-col",
    ]
    [
        TopBar.view { title: "Login with phone" },
        Html.div
            [
                Attr.class "flex flex-col w-full flex-1 p-4 gap-8",
            ]
            [
                Typography.view { text: "Enter the code sent to your phone" },
                TextField.view { label: "Code" },
                Button.view { label: "Verify code", href: routeToStr VerifyCode },
            ],
    ]

viewVerifiedCode : Html.Node
viewVerifiedCode = Html.div
    [
        Attr.class "w-full h-full flex flex-col",
    ]
    [
        TopBar.view { title: "Login with phone" },
        Html.div
            [
                Attr.class "flex flex-col w-full flex-1 p-4 gap-8",
            ]
            [
                Typography.view { text: "Logged in" },
                Button.view { label: "Go home", href: "/home" },
            ],
    ]

routeHx : Http.Request -> Task.Task Http.Response []
routeHx = \req ->
    when strToRoute req.url is
        Login ->
            viewSendCode |> Response.html |> Task.ok

        SendCode ->
            _ <- Sleep.millis 1000 |> Task.await
            SentCode |> routeToStr |> Response.redirect |> Task.ok

        SentCode ->
            viewVerifyCode |> Response.html |> Task.ok

        VerifyCode ->
            _ <- Sleep.millis 1000 |> Task.await
            VerifiedCode |> routeToStr |> Response.redirect |> Task.ok

        VerifiedCode ->
            viewVerifiedCode |> Response.html |> Task.ok

        Unknown ->
            Unknown |> routeToStr |> Response.redirect |> Task.ok
