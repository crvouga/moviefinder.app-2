module [KeyValueStore]

import pf.Task exposing [Task]

KeyValueStore : {
    get : Str -> Task.Task Str [NotFound, Errored Str],
    set : Str, Str -> Task.Task {} [Errored Str],
}
