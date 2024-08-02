module [init]

import Auth.VerifySms
import Auth.VerifySms.Impl.Fake as Fake
import Auth.VerifySms.Impl.Twilio as Twilio

Impl : [Fake Fake.Config, Twilio Twilio.Config]

init : Impl -> Auth.VerifySms.VerifySms
init = \impl ->
    when impl is
        Fake config ->
            Fake.init config

        Twilio config ->
            Twilio.init config
