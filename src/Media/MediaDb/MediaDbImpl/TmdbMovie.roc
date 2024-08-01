module [init, Config]

import pf.Task exposing [Task]
import Media.MediaDb.MediaDb exposing [MediaDb]
import Media.Media exposing [testData]

Config : { tmdbApiReadAccessToken : Str }

init : Config -> MediaDb
init = \_config -> {
    query: \_query ->
        Task.ok {
            rows: testData,
            limit: 20,
            offset: 0,
            total: 0,
        },
}
