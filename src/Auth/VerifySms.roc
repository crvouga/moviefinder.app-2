module [VerifySms, SendCode, VerifyCode]

import pf.Task exposing [Task]
import PhoneNumber exposing [PhoneNumber]

SendCode : { phoneNumber : PhoneNumber } -> Task {} []

# https://roc.zulipchat.com/#narrow/stream/231634-beginners/topic/Any.20tips.20resolving.20this.20roc.20run.20error.3F
VerifyCode : { phoneNumber : PhoneNumber, code : Str } -> Task {} []

VerifySms : {
    sendCode : SendCode,
    verifyCode : VerifyCode,
}
