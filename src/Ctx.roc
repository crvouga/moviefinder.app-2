module [Ctx, init]

import Auth.VerifySms.VerifySms as VerifySms
import Auth.VerifySms.VerifySmsFake as VerifySmsFake
# import Auth.VerifySms.VerifySmsTwilio as VerifySmsTwilio

Ctx : {
    verifySms : VerifySms.VerifySms,
}

init : Ctx
init = {
    verifySms: VerifySmsFake.init {
        code: "1234",
    },
}

