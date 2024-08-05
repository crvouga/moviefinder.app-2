module [VerifySms, SendCode, VerifyCode]

import pf.Task exposing [Task]
import PhoneNumber exposing [PhoneNumber]

SendCode : { phoneNumber : PhoneNumber } -> Task {} []

VerifyCode : { phoneNumber : PhoneNumber, code : Str } -> Task {} [WrongCode]

VerifySms : {
    sendCode : SendCode,
    verifyCode : VerifyCode,
}
