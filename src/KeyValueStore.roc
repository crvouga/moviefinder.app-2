module [KeyValueStore]

KeyValueStore a : {
    get : Str -> Task.Task a [],
    set : Str a -> Task.Task {} [],
}
