module [init, Config]

import Auth.VerifySms.VerifySms as VerifySms
import pf.Task
import pf.Sleep
import pf.Stdout

Config : {
    code : Str,
}

sendCode : Config -> VerifySms.SendCode
sendCode = \config -> \{ phone } ->
        Stdout.line! "VerifySmsTwilio. Sending code $(config.code) to phone number $(phone)"
        _ <- Sleep.millis 1000 |> Task.await
        Task.ok {}

verifyCode : Config -> VerifySms.VerifyCode
verifyCode = \_config -> \{ phone, code } ->
        Stdout.line! "VerifySmsTwilio. Verifying code $(code) for phone number $(phone)"
        _ <- Sleep.millis 1000 |> Task.await
        Task.ok {}

init : Config -> VerifySms.VerifySms
init = \config -> {
    sendCode: sendCode config,
    verifyCode: verifyCode config,
}
