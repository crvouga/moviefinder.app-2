module [init, Config]

import pf.Task exposing [Task]
#import pf.Http
import Media.MediaDb exposing [MediaDb]
import Media.Media exposing [testData]
#import json.Json

Config : { tmdbApiReadAccessToken : Str }

init : Config -> MediaDb
init = \_config -> {
    query: \_query ->
        #{ foo } = Http.get! "http://localhost:8000" Json.utf8

        Task.ok {
            rows: testData,
            limit: 20,
            offset: 0,
            total: 0,
        }
}
