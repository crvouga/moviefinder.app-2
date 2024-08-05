module [VerifySms, init, sendCode, verifyCode]

import pf.Task exposing [Task]
import PhoneNumber exposing [PhoneNumber]
import Auth.VerifySms.Fake as Fake
import Auth.VerifySms.Twilio as Twilio

Impl : [Fake Fake.Config, Twilio Twilio.Config]

VerifySms := {
    impl : Impl,
}

init : Impl -> VerifySms
init = \impl -> @VerifySms {
        impl,
    }

sendCode : VerifySms, { phoneNumber : PhoneNumber } -> Task {} []
sendCode = \@VerifySms verifySms, input ->
    when verifySms.impl is
        Fake config ->
            Fake.sendCode config input

        Twilio config ->
            Twilio.sendCode config input

verifyCode : VerifySms, { phoneNumber : PhoneNumber, code : Str } -> Task {} []
verifyCode = \@VerifySms verifySms, input ->
    when verifySms.impl is
        Fake config ->
            Fake.verifyCode config input

        Twilio config ->
            Twilio.verifyCode config input
