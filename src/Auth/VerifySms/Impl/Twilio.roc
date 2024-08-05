module [init, Config]

import Auth.VerifySms as VerifySms
import pf.Task
import pf.Sleep
import Logger
import PhoneNumber

Config : {
    code : Str,
    logger : Logger.Logger,
    
}

sendCode : Config -> VerifySms.SendCode
sendCode = \config -> \{ phoneNumber } ->
        config.logger.info! "VerifySmsFake. Sending code $(config.code) to phone number $(PhoneNumber.toStr phoneNumber)"
        _ <- Sleep.millis 1000 |> Task.await
        Task.ok {}

verifyCode : Config -> VerifySms.VerifyCode
verifyCode = \config -> \{ phoneNumber, code } ->
        config.logger.info! "VerifySmsFake. Verifying code $(code) for phone number $(PhoneNumber.toStr phoneNumber)"
        _ <- Sleep.millis 1000 |> Task.await
        if code != config.code then
            Task.ok {}
        else
            Task.ok {}

init : Config -> VerifySms.VerifySms
init = \config -> {
    sendCode: sendCode config,
    verifyCode: verifyCode config,
}
