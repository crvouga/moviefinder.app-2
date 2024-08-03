module [init, Config, getDiscoverMovie]

import pf.Task exposing [Task]
import pf.Http
import Media.MediaDb exposing [MediaDb, MediaDbQuery]
import Media exposing [Media]
import Logger
import Media.MediaDb.Impl.Tmdb as Tmdb
import Json exposing [decodeJsonWithFallback]

Config : {
    tmdbApiReadAccessToken : Str,
    logger : Logger.Logger,
}

TmdbDiscoverMovieResult : {
    adult : Bool,
    backdropPath : Str,
    genreIds : List I32,
    id : I32,
    originalLanguage : Str,
    originalTitle : Str,
    overview : Str,
    popularity : F32,
    posterPath : Str,
    releaseDate : Str,
    title : Str,
    video : Bool,
    voteAverage : F32,
    voteCount : I32,
}

TmdbDiscoverMovieResponse : {
    page : I32,
    totalPages : I32,
    totalResults : I32,
    results : List TmdbDiscoverMovieResult,
}

emptyResult : TmdbDiscoverMovieResponse
emptyResult = {
    page: 0,
    totalPages: 0,
    totalResults: 0,
    results: [],
}

getDiscoverMovie : Config -> Task (List Media) []
getDiscoverMovie = \config ->
    task =
        response = Http.send! (Tmdb.toRequest config "/discover/movie")
        discoverMovieResult = decodeJsonWithFallback! (Str.toUtf8 response) emptyResult
        mediaList = List.map discoverMovieResult.results tmdbMovieToMedia
        Task.ok mediaList

    task |> Task.onErr (\_ -> Task.ok [])

tmdbMovieToMedia : TmdbDiscoverMovieResult -> Media
tmdbMovieToMedia = \tmdbMovie -> {
    mediaId: Num.toStr tmdbMovie.id,
    mediaTitle: tmdbMovie.title,
    mediaDescription: "Str",
    mediaType: Movie,
    mediaPosterUrl: "Str",
}

query : Config -> MediaDbQuery
query = \config -> \queryInput ->
        mediaList = getDiscoverMovie! config

        sliced =
            mediaList

        Task.ok {
            rows: sliced,
            limit: queryInput.limit,
            offset: queryInput.offset,
            total: List.len mediaList,
        }

init : Config -> MediaDb
init = \config -> {
    query: query config,
}
