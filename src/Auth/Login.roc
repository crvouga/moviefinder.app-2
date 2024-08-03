module [routeHx]

import pf.Task
import Response
import Html
import Html.Attr as Attr
import Ui.TopBar as TopBar
import Ui.TextField as TextField
import Ui.Button as Button
import Ui.Typography as Typography
import Ctx
import Auth.Login.Route

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
        TopBar.view { title: "Login with phone" },
        Html.div
            [
                Attr.class "flex flex-col w-full flex-1 p-4 gap-8",
            ]
            [
                TextField.view {
                    label: "Phone number",
                    inputType: Tel,
                },
                Button.view {
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
        TopBar.view { title: "Login with phone" },
        Html.div
            [
                Attr.class "flex flex-col w-full flex-1 p-4 gap-8",
            ]
            [
                Typography.view { text: "Enter the code sent to your phone" },
                TextField.view { label: "Code", inputType: Tel },
                Button.view {
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
        TopBar.view { title: "Login with phone" },
        Html.div
            [
                Attr.class "flex flex-col w-full flex-1 p-4 gap-8",
            ]
            [
                Typography.view { text: "Logged in" },
                Button.view {
                    label: "Go home",
                    href: "/home",
                    target: "#app",
                },
            ],
    ]
