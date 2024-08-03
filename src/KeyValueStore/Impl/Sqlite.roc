module [init]

import pf.Task
import KeyValueStore

get : Str -> Task.Task a [NotFound]
get = \_key -> Task.err NotFound

set : Str, a -> Task.Task {} []
set = \_key, _value -> Task.ok {}

init : a -> KeyValueStore.KeyValueStore a
init = {
    get,
    set,
}
