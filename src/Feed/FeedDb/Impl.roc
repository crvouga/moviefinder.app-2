module [init]

import Feed.FeedDb exposing [FeedDb]
import Feed.FeedDb.Impl.KeyValueStore as KeyValueStore

Impl : [KeyValueStore KeyValueStore.Config]

init : Impl -> FeedDb
init = \impl ->
    when impl is
        KeyValueStore config ->
            KeyValueStore.init config
