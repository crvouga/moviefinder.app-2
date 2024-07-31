module [VerifySms, SendCode, VerifyCode, VerifyCodeErr, verifyCodeErrToStr]

import pf.Task

SendCode : { phone : Str } -> Task.Task {} []

VerifyCodeErr : [WrongCode, ExpiredCode]

verifyCodeErrToStr : VerifyCodeErr -> Str
verifyCodeErrToStr = \err ->
    when err is
        WrongCode -> "Wrong code"
        ExpiredCode -> "Expired code"

VerifyCode : { phone : Str, code : Str } -> Task.Task {} VerifyCodeErr

VerifySms : {
    sendCode : SendCode,
    verifyCode : VerifyCode,
}

