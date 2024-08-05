module [Config, init]

import pf.Task exposing [Task]
import pf.Sleep
import Logger
import PhoneNumber
import Auth.VerifySms

Config : {
    code : Str,
    logger : Logger.Logger,
}

sendCode : Config -> Auth.VerifySms.SendCode
sendCode = \config -> \{ phoneNumber } ->
        Logger.info! config.logger "Sending code $(config.code) to phone number $(PhoneNumber.toStr phoneNumber)"
        _ <- Sleep.millis 1000 |> Task.await
        Task.ok {}

verifyCode : Config -> Auth.VerifySms.VerifyCode
verifyCode = \config -> \{ phoneNumber, code } ->
        Logger.info! config.logger "Verifying code $(code) for phone number $(PhoneNumber.toStr phoneNumber)"
        _ <- Sleep.millis 1000 |> Task.await
        if code != config.code then
            Task.ok {}
        else
            Task.ok {}

init : Config -> Auth.VerifySms.VerifySms
init = \config -> {
    sendCode: sendCode config,
    verifyCode: verifyCode config,
}
