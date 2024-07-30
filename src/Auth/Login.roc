module [routeHx]

import Html.Html as Html
import Html.Attr as Attr
import Ui.TopBar as TopBar
import Ui.TextField as TextField
import Ui.Button as Button

import pf.Task
import pf.Http
import pf.Sleep
import Response

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
                Button.view { label: "Send code", href: "/login/send-code" },
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
                TextField.view { label: "Code" },
                Button.view { label: "Verify code", href: "/login/verify-code" },
            ],
    ]

routeHx : Http.Request -> Task.Task Http.Response []
routeHx = \req ->
    when req.url is
        "/login" ->
            viewSendCode |> Response.html |> Task.ok

        "/login/send-code" ->
            _ <- Sleep.millis 1000 |> Task.await
            "/home" |> Response.redirect |> Task.ok

        "/login/verify-code" ->
            viewVerifyCode |> Response.html |> Task.ok

        _ ->
            "/home" |> Response.redirect |> Task.ok
