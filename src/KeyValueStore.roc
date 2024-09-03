module [KeyValueStore]

KeyValueStore : {
    get : Str -> Task.Task Str [NotFound, Errored Str],
    put : Str, Str -> Task.Task {} [Errored Str],
}
