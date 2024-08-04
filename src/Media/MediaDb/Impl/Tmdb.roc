module [baseUrl, toRequest, toBaseHeaders, TmdbConfig, getTmdbConfig, pageSize]

import pf.Task exposing [Task]
import pf.Http
import Json

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

pageSize : I32
pageSize = 20

# https://developer.themoviedb.org/reference/configuration-details
TmdbConfig : {
    images : {
        baseUrl : Str,
        secureBaseUrl : Str,
        backdropSizes : List Str,
        logoSizes : List Str,
        posterSizes : List Str,
        profileSizes : List Str,
        stillSizes : List Str,
    },
    changeKeys : List Str,
}

emptyTmdbConfig : TmdbConfig
emptyTmdbConfig = {
    images: {
        baseUrl: "",
        secureBaseUrl: "",
        backdropSizes: [],
        logoSizes: [],
        posterSizes: [],
        profileSizes: [],
        stillSizes: [],
    },
    changeKeys: [],
}

# https://developer.themoviedb.org/reference/configuration-details
getTmdbConfig :
    {
        tmdbApiReadAccessToken : Str,
    }*
    -> Task TmdbConfig []
getTmdbConfig = \config ->
    task =
        response = Http.send! (toRequest config "/configuration")
        tmdbConfig = Json.decodeWithFallback (Str.toUtf8 response) emptyTmdbConfig
        Task.ok tmdbConfig

    task |> Task.onErr (\_ -> Task.ok emptyTmdbConfig)
