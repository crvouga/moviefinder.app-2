module [Route, encode, decode]

import Url exposing [Url]
import PhoneNumber exposing [PhoneNumber]

Route : [SendCode, ClickedSendCode, VerifyCode { phoneNumber : PhoneNumber, error : Str }, ClickedVerifyCode { phoneNumber : PhoneNumber }, VerifiedCode]

appendParamPhoneNumber : Url, PhoneNumber -> Url
appendParamPhoneNumber = \url, phoneNumber ->
    url |> Url.appendParam "phoneNumber" (PhoneNumber.toUrlSafeStr phoneNumber)

encode : Route -> Url
encode = \route ->
    when route is
        SendCode -> Url.fromStr "/login/send-code"
        ClickedSendCode -> Url.fromStr "/login/clicked-send-code"
        VerifyCode { phoneNumber } -> "/login/verify-code" |> Url.fromStr |> appendParamPhoneNumber phoneNumber
        ClickedVerifyCode { phoneNumber } -> "/login/clicked-verify-code" |> Url.fromStr |> appendParamPhoneNumber phoneNumber
        VerifiedCode -> Url.fromStr "/login/verified-code"

decode : Url -> Route
decode = \url ->
    when Url.path url is
        "/login/send-code" -> SendCode
        "/login/clicked-send-code" -> ClickedSendCode
        "/login/verify-code" ->
            parsedPhoneNumber = url |> Url.queryParams |> Dict.get "phoneNumber" |> Result.withDefault "" |> PhoneNumber.fromUrlSafeStr
            when parsedPhoneNumber is
                Err InvalidPhoneNumber -> SendCode
                Ok phoneNumber -> VerifyCode { phoneNumber, error: "" }

        "/login/clicked-verify-code" ->
            parsedPhoneNumber = url |> Url.queryParams |> Dict.get "phoneNumber" |> Result.withDefault "" |> PhoneNumber.fromUrlSafeStr
            when parsedPhoneNumber is
                Err InvalidPhoneNumber -> SendCode
                Ok phoneNumber -> ClickedVerifyCode { phoneNumber }

        "/login/verified-code" -> VerifiedCode
        _ -> SendCode
