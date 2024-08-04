module [init, Config, getDiscoverMovie]

import pf.Task exposing [Task]
import pf.Http
import Media.MediaDb exposing [MediaDb, MediaDbQuery, MediaQuery]
import Media exposing [Media]
import Logger
import Media.MediaDb.Impl.Tmdb as Tmdb
import Json
import ImageSet
import MediaId
import Url
# import pf.Stdout

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

getDiscoverMovie : Config, MediaQuery -> Task (List Media) []
getDiscoverMovie = \config, mediaQuery ->
    task =
        page = mediaQuery.offset // mediaQuery.limit + 1
        url =
            # https://developer.themoviedb.org/reference/discover-movie
            "/discover/movie"
            |> Url.fromStr
            |> Url.appendParam "page" (page |> Num.toStr)
            |> Url.toStr

        response = Http.send! (Tmdb.toRequest config url)
        discoverMovieResult = Json.decodeWithFallback (Str.toUtf8 response) emptyResult

        tmdbConfig = Tmdb.getTmdbConfig! config

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
        rows = getDiscoverMovie! config queryInput

        Task.ok {
            limit: queryInput.limit,
            offset: queryInput.offset,
            total: List.len rows,
            rows,
        }

init : Config -> MediaDb
init = \config -> {
    query: query config,
}
