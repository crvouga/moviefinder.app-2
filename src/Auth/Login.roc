module [routeHx]

import pf.Task
import Response
import Html
import Html.Attr as Attr
import App.TopBar
import Ui.TextField
import Ui.Button
import Ui.Typography
import Ctx
import Auth.Login.Route
import Route

routeHx : Ctx.Ctx, Auth.Login.Route.Route -> Task.Task Response.Response _
routeHx = \ctx, route ->
    when route is
        SendCode ->
            viewSendCode |> Response.html |> Task.ok

        ClickedSendCode ->
            ctx.verifySms.sendCode! { phone: "123" }
            Login VerifyCode |> Response.redirect |> Task.ok

        VerifyCode ->
            viewVerifyCode |> Response.html |> Task.ok

        ClickedVerifyCode ->
            responseOk =
                Login VerifiedCode |> Response.redirect |> Task.ok

            task =
                ctx.verifySms.verifyCode! { phone: "123", code: "123" }
                responseOk

            task |> Task.onErr \_ -> responseOk

        VerifiedCode ->
            viewVerifiedCode |> Response.html |> Task.ok

viewSendCode : Html.Node
viewSendCode = Html.div
    [
        Attr.class "w-full h-full flex flex-col",
    ]
    [
        App.TopBar.view { title: "Login with phone", back: Account Account },
        Html.div
            [
                Attr.class "flex flex-col w-full flex-1 p-4 gap-8",
            ]
            [
                Ui.TextField.view {
                    label: "Phone number",
                    inputType: Tel,
                },
                Ui.Button.a {
                    label: "Send code",
                    href: Auth.Login.Route.encode ClickedSendCode,
                    target: "#app",
                },
            ],
    ]

viewVerifyCode : Html.Node
viewVerifyCode = Html.div
    [
        Attr.class "w-full h-full flex flex-col",
    ]
    [
        App.TopBar.view { title: "Login with phone", back: Login SendCode },
        Html.div
            [
                Attr.class "flex flex-col w-full flex-1 p-4 gap-8",
            ]
            [
                Ui.Typography.view { text: "Enter the code sent to your phone" },
                Ui.TextField.view { label: "Code", inputType: Tel },
                Ui.Button.a {
                    label: "Verify code",
                    href: Auth.Login.Route.encode ClickedVerifyCode,
                    target: "#app",
                },
            ],
    ]

viewVerifiedCode : Html.Node
viewVerifiedCode = Html.div
    [
        Attr.class "w-full h-full flex flex-col",
    ]
    [
        App.TopBar.view { title: "Login with phone", back: Feed Feed },
        Html.div
            [
                Attr.class "flex flex-col w-full flex-1 p-4 gap-8",
            ]
            [
                Ui.Typography.view { text: "Logged in" },
                Ui.Button.a {
                    label: "Go home",
                    href: (Feed Feed) |> Route.encode,
                    target: "#app",
                },
            ],
    ]
