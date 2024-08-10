module [Route, encode, decode]

import Url exposing [Url]
import PhoneNumber exposing [PhoneNumber]
import Auth.VerifyCodeErr as VerifyCodeErr exposing [VerifyCodeErr]

Route : [
    SendCode,
    ClickedSendCode,
    VerifyCode { phoneNumber : PhoneNumber, error : [Some VerifyCodeErr, None] },
    ClickedVerifyCode { phoneNumber : PhoneNumber },
    VerifiedCode,
]

appendParamPhoneNumber : Url, PhoneNumber -> Url
appendParamPhoneNumber = \url, phoneNumber ->
    url |> Url.appendParam "phoneNumber" (PhoneNumber.toUrlSafeStr phoneNumber)

encode : Route -> Url
encode = \route ->
    when route is
        SendCode ->
            Url.fromStr "/login/send-code"

        ClickedSendCode ->
            Url.fromStr "/login/clicked-send-code"

        VerifyCode payload ->
            "/login/verify-code"
            |> Url.fromStr
            |> appendParamPhoneNumber payload.phoneNumber
            |> \url ->
                when payload.error is
                    Some errStr ->
                        Url.appendParam url "error" (VerifyCodeErr.encode errStr)

                    None ->
                        url

        ClickedVerifyCode { phoneNumber } ->
            "/login/clicked-verify-code"
            |> Url.fromStr
            |> appendParamPhoneNumber phoneNumber

        VerifiedCode ->
            Url.fromStr "/login/verified-code"

decode : Url -> Route
decode = \url ->
    when Url.path url is
        "/login/send-code" ->
            SendCode

        "/login/clicked-send-code" ->
            ClickedSendCode

        "/login/verify-code" ->
            parsedPhoneNumber =
                url
                |> Url.queryParams
                |> Dict.get "phoneNumber"
                |> Result.withDefault ""
                |> PhoneNumber.fromUrlSafeStr

            error =
                url
                |> Url.queryParams
                |> Dict.get "error"
                |> \result ->
                    when result is
                        Ok errStr -> Some (VerifyCodeErr.decode errStr)
                        Err _ -> None

            when parsedPhoneNumber is
                Err InvalidPhoneNumber -> SendCode
                Ok phoneNumber -> VerifyCode { phoneNumber, error }

        "/login/clicked-verify-code" ->
            parsedPhoneNumber =
                url
                |> Url.queryParams
                |> Dict.get "phoneNumber"
                |> Result.withDefault ""
                |> PhoneNumber.fromUrlSafeStr

            when parsedPhoneNumber is
                Err InvalidPhoneNumber ->
                    SendCode

                Ok phoneNumber ->
                    ClickedVerifyCode { phoneNumber }

        "/login/verified-code" ->
            VerifiedCode

        _ ->
            SendCode
