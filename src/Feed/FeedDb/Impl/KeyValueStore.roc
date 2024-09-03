module [Config, init]

import KeyValueStore exposing [KeyValueStore]
import Feed.FeedDb exposing [FeedDb, Get, Put]

import Feed.Feed as Feed

Config : {
    keyValueStore : KeyValueStore,
}

get : Config -> Get
get = \config -> \feedId ->
        got <- (config.keyValueStore.get feedId) |> Task.attempt
        when got is
            Err _ -> Task.err NotFound
            Ok gotValue ->
                decoded = Feed.decode gotValue
                when decoded is
                    Err _ -> Task.err NotFound
                    Ok feed ->
                        Task.ok feed

put : Config -> Put
put = \config -> \feed ->
        encoded = Feed.encode feed
        config.keyValueStore.put feed.feedId encoded

init : Config -> FeedDb
init = \config -> {
    get: get config,
    put: put config,
}
