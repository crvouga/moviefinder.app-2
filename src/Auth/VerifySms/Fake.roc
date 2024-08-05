module [Config, verifyCode, sendCode]

import pf.Task exposing [Task]
import pf.Sleep
import Logger
import PhoneNumber exposing [PhoneNumber]

Config : {
    code : Str,
    logger : Logger.Logger,
}

sendCode : Config, { phoneNumber : PhoneNumber } -> Task {} []
sendCode = \config, { phoneNumber } ->
    Logger.info! config.logger "Sending code $(config.code) to phone number $(PhoneNumber.toStr phoneNumber)"
    _ <- Sleep.millis 1000 |> Task.await
    Task.ok {}

verifyCode : Config, { phoneNumber : PhoneNumber, code : Str } -> Task {} []
verifyCode = \config, { phoneNumber, code } ->
    Logger.info! config.logger "Verifying code $(code) for phone number $(PhoneNumber.toStr phoneNumber)"
    _ <- Sleep.millis 1000 |> Task.await
    if code != config.code then
        Task.ok {}
    else
        Task.ok {}
