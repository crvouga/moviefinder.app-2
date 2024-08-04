module [init, Config, getDiscoverMovie]

import pf.Task exposing [Task]
import pf.Http
import Media.MediaDb exposing [MediaDb, MediaDbQuery]
import Media exposing [Media]
import Logger
import Media.MediaDb.Impl.Tmdb as Tmdb
import Json exposing [decodeJsonWithFallback]
import ImageSet
import MediaId
import pf.Stdout

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
        tmdbConfig = Tmdb.getTmdbConfig! config
        Stdout.line! (Inspect.toStr tmdbConfig)
        response = Http.send! (Tmdb.toRequest config "/discover/movie")
        discoverMovieResult = decodeJsonWithFallback! (Str.toUtf8 response) emptyResult
        mediaList = List.map discoverMovieResult.results \tmdbMovie -> tmdbMovieToMedia tmdbConfig tmdbMovie
        Task.ok mediaList

    task |> Task.onErr (\_ -> Task.ok [])

toPosterImageSet : Tmdb.TmdbConfig, Str -> ImageSet.ImageSet
toPosterImageSet = \tmdbConfig, posterPath ->
    tmdbConfig.images.posterSizes
    |> List.map \size -> [tmdbConfig.images.baseUrl, size, posterPath] |> Str.joinWith ""
    |> \lowestResFirst -> ImageSet.init { lowestResFirst }

tmdbMovieToMedia : Tmdb.TmdbConfig, TmdbDiscoverMovieResult -> Media
tmdbMovieToMedia = \tmdbConfig, tmdbMovie -> {
    mediaId: tmdbMovie.id |> Num.toStr |> MediaId.fromStr,
    mediaTitle: tmdbMovie.title,
    mediaDescription: tmdbMovie.overview,
    mediaType: Movie,
    mediaPoster: toPosterImageSet tmdbConfig tmdbMovie.posterPath,
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
