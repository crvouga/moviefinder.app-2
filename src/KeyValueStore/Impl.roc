module [init, Impl]

import KeyValueStore
import KeyValueStore.Impl.Sqlite

Impl : [Sqlite KeyValueStore.Impl.Sqlite.Config]

init : Impl -> KeyValueStore.KeyValueStore
init = \impl ->
    when impl is
        Sqlite config ->
            KeyValueStore.Impl.Sqlite.init config
