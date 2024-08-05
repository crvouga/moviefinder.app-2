module [init]

import Auth.VerifySms
import Auth.VerifySms.Impl.Fake

Impl : [Fake Auth.VerifySms.Impl.Fake.Config]

init : Impl -> Auth.VerifySms.VerifySms
init = \impl ->
    when impl is
        Fake config ->
            Auth.VerifySms.Impl.Fake.init config
