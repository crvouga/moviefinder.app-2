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
import Hx
import PhoneNumber

routeHx : Ctx.Ctx, Auth.Login.Route.Route -> Task.Task Response.Response _
routeHx = \ctx, route ->
    when route is
        SendCode ->
            viewSendCode |> Response.html |> Task.ok

        ClickedSendCode ->
            parsedPhoneNumber =
                ctx.req.formData
                |> Dict.get "phoneNumber"
                |> Result.withDefault ""
                |> PhoneNumber.fromStr

            when parsedPhoneNumber is
                Err InvalidPhoneNumber ->
                    Task.ok (Response.redirect (Login SendCode))

                Ok phoneNumber ->
                    ctx.verifySms.sendCode! { phoneNumber }
                    Login (VerifyCode { phoneNumber }) |> Response.redirect |> Task.ok

        VerifyCode { phoneNumber } ->
            viewVerifyCode { phoneNumber } |> Response.html |> Task.ok

        ClickedVerifyCode { phoneNumber } ->
            responseOk =
                Login VerifiedCode |> Response.redirect |> Task.ok

            task =
                ctx.verifySms.verifyCode! { phoneNumber, code: "123" }
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
        Html.form
            [
                Attr.class "flex flex-col w-full flex-1 p-4 gap-8",
                Hx.swap InnerHtml,
                Hx.target "#app",
                Hx.trigger Submit,
                Hx.pushUrl,
                Hx.post (Auth.Login.Route.encode ClickedSendCode),
            ]
            [
                Ui.TextField.view {
                    label: "Phone number",
                    inputType: Tel,
                    name: "phoneNumber",
                },
                Ui.Button.button [] {
                    label: "Send code",
                },
            ],
    ]

viewVerifyCode : { phoneNumber : PhoneNumber.PhoneNumber } -> Html.Node
viewVerifyCode = \{ phoneNumber } -> Html.div
        [
            Attr.class "w-full h-full flex flex-col",
        ]
        [
            App.TopBar.view { title: "Login with phone", back: Login SendCode },
            Html.form
                [
                    Attr.class "flex flex-col w-full flex-1 p-4 gap-8",
                    Hx.swap InnerHtml,
                    Hx.target "#app",
                    Hx.trigger Submit,
                    Hx.pushUrl,
                    Hx.post (Auth.Login.Route.encode (ClickedVerifyCode { phoneNumber })),
                ]
                [
                    Ui.Typography.view {
                        text: "Enter the code sent to $(PhoneNumber.format phoneNumber)",
                        class: "text-lg font-bold pt-4",
                    },
                    Ui.TextField.view {
                        label: "Code",
                        name: "code",
                        inputType: Tel,
                    },
                    Ui.Button.button [] {
                        label: "Verify code",
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
