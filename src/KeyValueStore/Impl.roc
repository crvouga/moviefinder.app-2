module [init, Impl]

import KeyValueStore
import KeyValueStore.Impl.Sqlite

Impl : [Sqlite]

init : Impl -> KeyValueStore.KeyValueStore a
init = \impl ->
    when impl is
        Sqlite ->
            KeyValueStore.Impl.Sqlite.init
