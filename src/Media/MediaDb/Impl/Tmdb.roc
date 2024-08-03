module [baseUrl, Config, toBaseHeaders, toRequest, toBaseHeaders]

import pf.Http

Config : {
    tmdbApiReadAccessToken : Str,
}

baseUrl : Str
baseUrl = "https://api.themoviedb.org/3"

toBaseHeaders :
    {
        tmdbApiReadAccessToken : Str,
    }*
    -> List { name : Str, value : List U8 }
toBaseHeaders = \config -> [
    {
        name: "Authorization",
        value: Str.toUtf8 "Bearer $(config.tmdbApiReadAccessToken)",
    },
]

toRequest :
    {
        tmdbApiReadAccessToken : Str,
    }*,
    Str
    -> Http.Request
toRequest = \config, path -> { Http.defaultRequest &
        headers: toBaseHeaders config,
        url: "$(baseUrl)$(path)",
    }
