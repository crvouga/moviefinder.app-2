module [VerifySms, SendCode, VerifyCode]

import pf.Task

SendCode : { phone : Str } -> Task.Task {} []

VerifyCode : { phone : Str, code : Str } -> Task.Task {} []

VerifySms : {
    sendCode : SendCode,
    verifyCode : VerifyCode,
}

