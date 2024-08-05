module [VerifySms, SendCode, VerifyCode]

import pf.Task
import PhoneNumber exposing [PhoneNumber]

SendCode : { phoneNumber : PhoneNumber } -> Task.Task {} []

VerifyCode : { phoneNumber : PhoneNumber, code : Str } -> Task.Task {} []

VerifySms : {
    sendCode : SendCode,
    verifyCode : VerifyCode,
}

