module [Config, init]

import pf.Task exposing [Task]
# import pf.Sleep
import Logger
# import PhoneNumber
import Auth.VerifySms

Config : {
    code : Str,
    logger : Logger.Logger,
}

sendCode : Config -> Auth.VerifySms.SendCode
sendCode = \_config -> \_input ->
        # Logger.info! config.logger "Sending code $(config.code) to phone number $(PhoneNumber.toStr input.phoneNumber)"
        # Sleep.millis! 1000
        Task.ok {}

verifyCode : Config -> Auth.VerifySms.VerifyCode
verifyCode = \config -> \input ->
        # Logger.info! config.logger "Verifying code $(input.code) for phone number $(PhoneNumber.toStr input.phoneNumber)"
        # Sleep.millis! 1000
        if input.code != config.code then
            Task.ok {}
        else
            Task.ok {}

init : Config -> Auth.VerifySms.VerifySms
init = \config -> {
    sendCode: sendCode config,
    verifyCode: verifyCode config,
}
