module [init, Config]

import pf.Task exposing [Task]
import Media.MediaDb.MediaDb exposing [MediaDb]

Config : { tmdbApiReadAccessToken : Str }

init : Config -> MediaDb
init = \_config -> {
    find: \_query -> Task.ok {
            rows: [],
            limit: 20,
            offset: 0,
            total: 0,
        },
}
