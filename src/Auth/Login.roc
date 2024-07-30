module [routeHx, strToRoute, Route]

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

Route : [SendCode, ClickedSendCode, VerifyCode, ClickedVerifyCode, VerifiedCode, Unknown]

strToRoute : Str -> Route
strToRoute = \str ->
    when str is
        "/login" -> SendCode
        "/login/clicked-send-code" -> ClickedSendCode
        "/login/verify-code" -> VerifyCode
        "/login/clicked-verify-code" -> ClickedVerifyCode
        "/login/verified-code" -> VerifiedCode
        _ -> Unknown

routeToStr : Route -> Str
routeToStr = \route ->
    when route is
        SendCode -> "/login"
        ClickedSendCode -> "/login/clicked-send-code"
        VerifyCode -> "/login/verify-code"
        ClickedVerifyCode -> "/login/clicked-verify-code"
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
                Button.view { label: "Send code", href: routeToStr ClickedSendCode },
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
                Button.view { label: "Verify code", href: routeToStr ClickedVerifyCode },
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
        SendCode ->
            viewSendCode |> Response.html |> Task.ok

        ClickedSendCode ->
            _ <- Sleep.millis 1000 |> Task.await
            VerifyCode |> routeToStr |> Response.redirect |> Task.ok

        VerifyCode ->
            viewVerifyCode |> Response.html |> Task.ok

        ClickedVerifyCode ->
            _ <- Sleep.millis 1000 |> Task.await
            VerifiedCode |> routeToStr |> Response.redirect |> Task.ok

        VerifiedCode ->
            viewVerifiedCode |> Response.html |> Task.ok

        Unknown ->
            Unknown |> routeToStr |> Response.redirect |> Task.ok
