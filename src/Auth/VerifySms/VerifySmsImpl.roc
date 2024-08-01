module [init]

import Auth.VerifySms.VerifySms exposing [VerifySms]
import Auth.VerifySms.VerifySmsImpl.Fake as Fake
import Auth.VerifySms.VerifySmsImpl.Twilio as Twilio

Impl : [Fake Fake.Config, Twilio Twilio.Config]

init : Impl -> VerifySms
init = \impl ->
    when impl is
        Fake config ->
            Fake.init config

        Twilio config ->
            Twilio.init config
