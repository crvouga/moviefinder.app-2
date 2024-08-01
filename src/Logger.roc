module [init, Logger, child]

import pf.Stdout
import pf.Utc
import pf.Task

Info : Str -> Task.Task {} []

Logger : {
    namespace : List Str,
    info : Info,
}

namespaceToStr : List Str -> Str
namespaceToStr = \namepsace ->
    Str.joinWith (List.map namepsace \str -> "[$(str)]") " "

info : List Str -> Info
info = \namespace -> \msg ->
        date = Utc.now! |> Utc.toIso8601Str
        Stdout.line! "$(date) $(namespaceToStr namespace) $(msg)"

child : Logger, List Str -> Logger
child = \logger, namespace ->
    namespaceNew = List.concat logger.namespace namespace
    {
        namespace: namespaceNew,
        info: info namespaceNew,
    }

init : List Str -> Logger
init = \namespace -> {
    namespace,
    info: info namespace,
}
