module [init, Logger, info]

import pf.Stdout
import pf.Utc
import pf.Task

Impl : [Std]

Logger : {
    namespace : List Str,
    impl : Impl,
}

namespaceToStr : List Str -> Str
namespaceToStr = \namepsace ->
    Str.joinWith (List.map namepsace \str -> "[$(str)]") " "

info : Logger, Str -> Task.Task {} *
info = \logger, msg ->
    date = Utc.now! |> Utc.toIso8601Str
    Stdout.line! "$(date) $(namespaceToStr logger.namespace) $(msg)"

init : List Str -> Logger
init = \namespace -> {
    namespace,
    impl: Std,
}
