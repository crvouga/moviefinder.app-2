module [VerifySms, SendCode, VerifyCode]

import PhoneNumber exposing [PhoneNumber]
import Auth.VerifyCodeErr exposing [VerifyCodeErr]

SendCode : { phoneNumber : PhoneNumber } -> Task {} [Errored Str]

VerifyCode : { phoneNumber : PhoneNumber, code : Str } -> Task {} VerifyCodeErr

VerifySms : {
    sendCode : SendCode,
    verifyCode : VerifyCode,
}
