module [Route, encode, decode]

import Url exposing [Url]

Route : [SendCode, ClickedSendCode, VerifyCode, ClickedVerifyCode, VerifiedCode]

encode : Route -> Url
encode = \route ->
    when route is
        SendCode -> Url.fromStr "/login/send-code"
        ClickedSendCode -> Url.fromStr "/login/clicked-send-code"
        VerifyCode -> Url.fromStr "/login/verify-code"
        ClickedVerifyCode -> Url.fromStr "/login/clicked-verify-code"
        VerifiedCode -> Url.fromStr "/login/verified-code"

decode : Url -> Route
decode = \url ->
    when Url.path url is
        "/login/send-code" -> SendCode
        "/login/clicked-send-code" -> ClickedSendCode
        "/login/verify-code" -> VerifyCode
        "/login/clicked-verify-code" -> ClickedVerifyCode
        "/login/verified-code" -> VerifiedCode
        _ -> SendCode
