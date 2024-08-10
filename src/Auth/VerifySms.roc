module [VerifySms, SendCode, VerifyCode]

import pf.Task exposing [Task]
import PhoneNumber exposing [PhoneNumber]

SendCode : { phoneNumber : PhoneNumber } -> Task {} [Errored Str]

VerifyCode : { phoneNumber : PhoneNumber, code : Str } -> Task {} [WrongCode, Errored Str]

VerifySms : {
    sendCode : SendCode,
    verifyCode : VerifyCode,
}
