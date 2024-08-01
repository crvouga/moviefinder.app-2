module [init, Logger]

import pf.Stdout
import pf.Utc

Logger : {
    info : Str -> Task {} *,
}

info : Str -> Task.Task {} *
info = \msg ->
    date = Utc.now! |> Utc.toIso8601Str
    Stdout.line! msg

init : Logger
init = {
    info,
}
