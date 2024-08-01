module [Route, encode, decode]

Route : [SendCode, ClickedSendCode, VerifyCode, ClickedVerifyCode, VerifiedCode]

encode : Route -> Str
encode = \route ->
    when route is
        SendCode -> "/login/send-code"
        ClickedSendCode -> "/login/clicked-send-code"
        VerifyCode -> "/login/verify-code"
        ClickedVerifyCode -> "/login/clicked-verify-code"
        VerifiedCode -> "/login/verified-code"

decode : Str -> Route
decode = \str ->
    when str is
        "/login/send-code" -> SendCode
        "/login/clicked-send-code" -> ClickedSendCode
        "/login/verify-code" -> VerifyCode
        "/login/clicked-verify-code" -> ClickedVerifyCode
        "/login/verified-code" -> VerifiedCode
        _ -> SendCode
