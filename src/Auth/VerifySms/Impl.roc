module [init]

import Auth.VerifySms
import Auth.VerifySms.Impl.Fake
import Auth.VerifySms.Impl.Twilio

Impl : [Fake Auth.VerifySms.Impl.Fake.Config, Twilio Auth.VerifySms.Impl.Twilio.Config]

init : Impl -> Auth.VerifySms.VerifySms
init = \impl ->
    when impl is
        Fake config ->
            Auth.VerifySms.Impl.Fake.init config

        Twilio config ->
            Auth.VerifySms.Impl.Twilio.init config
