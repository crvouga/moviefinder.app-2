module [init, Config, getDiscoverMovie]

import pf.Http
import Pagination
import Media.MediaDb exposing [MediaDb, Find, FindById, MediaQuery]
import Media.Media exposing [Media]
import Logger
import Json
import ImageSet
import Media.MediaId as MediaId
import Tmdb
import Media.MediaVideo as MediaVideo
import Url
import json.OptionOrNull exposing [OptionOrNull]
# import pf.Stdout

Config : {
    tmdbApiReadAccessToken : Str,
    logger : Logger.Logger,
}

TmdbDiscoverMovieResult : {
    adult : OptionOrNull Bool,
    backdropPath : OptionOrNull Str,
    genreIds : OptionOrNull (List U64),
    id : OptionOrNull U64,
    originalLanguage : OptionOrNull Str,
    originalTitle : OptionOrNull Str,
    overview : OptionOrNull Str,
    popularity : OptionOrNull F32,
    posterPath : OptionOrNull Str,
    releaseDate : OptionOrNull Str,
    title : OptionOrNull Str,
    video : OptionOrNull Bool,
    voteAverage : OptionOrNull F32,
    voteCount : OptionOrNull U64,
}

TmdbDiscoverMovieResponse : {
    page : OptionOrNull U64,
    totalPages : OptionOrNull U64,
    totalResults : OptionOrNull U64,
    results : OptionOrNull (List (OptionOrNull TmdbDiscoverMovieResult)),
}

# emptyResult : TmdbDiscoverMovieResponse
# emptyResult = {
#     page: 0,
#     totalPages: 0,
#     totalResults: 0,
#     results: [],
# }

pageSize = 20

getDiscoverMovie : Config, MediaQuery -> Task (List Media) []
getDiscoverMovie = \config, mediaQuery ->
    task =
        pageBased = Pagination.toPageBased pageSize {
            limit: mediaQuery.limit,
            offset: mediaQuery.offset,
        }

        req =
            # https://developer.themoviedb.org/reference/discover-movie
            "/discover/movie"
            |> Url.fromStr
            |> Url.appendParam "page" (pageBased.page |> Num.toStr)
            |> Url.appendParam "include_adult" "false"
            |> Url.toStr
            |> \url -> Tmdb.toRequest config url

        res = Http.send! req

        decoded : Result TmdbDiscoverMovieResponse _
        decoded = Json.decode (Str.toUtf8 res)

        when decoded is
            Err _ ->
                Task.ok []

            Ok parsed ->
                tmdbConfig = Tmdb.getTmdbConfig! config

                mediaList =
                    parsed.results
                    |> OptionOrNull.getResult
                    |> Result.withDefault []
                    |> List.keepOks OptionOrNull.getResult
                    |> List.map \tmdbMovie -> tmdbMovieToMedia tmdbConfig tmdbMovie

                Task.ok mediaList

    task |> Task.onErr (\_ -> Task.ok [])

tmdbMovieToMedia : Tmdb.TmdbConfig, TmdbDiscoverMovieResult -> Media
tmdbMovieToMedia = \tmdbConfig, tmdbMovie -> {
    mediaId: tmdbMovie.id |> OptionOrNull.getResult |> Result.withDefault 0 |> Num.toStr |> MediaId.fromStr,
    mediaTitle: tmdbMovie.title |> OptionOrNull.getResult |> Result.withDefault "",
    mediaDescription: tmdbMovie.overview |> OptionOrNull.getResult |> Result.withDefault "",
    mediaType: Movie,
    mediaPoster: tmdbMovie.posterPath |> OptionOrNull.getResult |> Result.withDefault "" |> \path -> Tmdb.toPosterImageSet tmdbConfig path,
    mediaBackdrop: tmdbMovie.backdropPath |> OptionOrNull.getResult |> Result.withDefault "" |> \path -> Tmdb.toBackdropImageSet tmdbConfig path,
    mediaVideos: [],
}

find : Config -> Find
find = \config -> \queryInput ->
        page = getDiscoverMovie! config queryInput
        nextPage = getDiscoverMovie! config { queryInput & offset: queryInput.offset + pageSize }

        indexWithinPage = Pagination.toIndexWithinPage pageSize {
            limit: queryInput.limit,
            offset: queryInput.offset,
        }
        rows =
            List.concat page nextPage
            |> List.dropFirst indexWithinPage

        Task.ok {
            limit: queryInput.limit,
            offset: queryInput.offset,
            total: List.len rows,
            rows,
        }

emptyMedia : Media
emptyMedia = {
    mediaId: MediaId.fromStr "0",
    mediaTitle: "",
    mediaDescription: "",
    mediaType: Movie,
    mediaPoster: ImageSet.init { lowestResFirst: [] },
    mediaBackdrop: ImageSet.init { lowestResFirst: [] },
    mediaVideos: [],
}

TmdbVideo : {
    iso6391 : Str,
    iso31661 : Str,
    name : Str,
    key : Str,
    site : Str,
    size : U32,
    type : Str,
    official : Bool,
    publishedAt : Str,
    id : Str,
}

TmdbMovieDetails : {
    # adult : Bool,
    backdropPath : Str,
    # budget : U32,
    # genres : List {
    #     id : U32,
    #     name : Str,
    # },
    # homepage : Str,
    id : U32,
    # imdbId : Str,
    # originCountry : List Str,
    # originalLanguage : Str,
    # originalTitle : Str,
    overview : Str,
    # popularity : F32,
    posterPath : Str,
    # productionCompanies : List {
    #     id : U32,
    #     logoPath : Str,
    #     name : Str,
    #     originCountry : Str,
    # },
    # productionCountries : List {
    #     iso31661 : Str,
    #     name : Str,
    # },
    # releaseDate : Str,
    # revenue : U32,
    # runtime : U32,
    # spokenLanguages : List {
    #     englishName : Str,
    #     iso6391 : Str,
    #     name : Str,
    # },
    # status : Str,
    # tagline : Str,
    title : Str,
    # video : Bool,
    # voteAverage : F32,
    # voteCount : U32,
    videos : {
        results : List TmdbVideo,
    },
}

tmdbVideoToMediaVideo : TmdbVideo -> MediaVideo.MediaVideo
tmdbVideoToMediaVideo = \tmdbVideo -> MediaVideo.init {
        id: tmdbVideo.id,
        youtubeId: tmdbVideo.key,
        name: tmdbVideo.name,
    }

tmdbMovieDetailsToMedia : Tmdb.TmdbConfig, TmdbMovieDetails -> Media
tmdbMovieDetailsToMedia = \tmdbConfig, tmdbMovieDetails -> {
    mediaId: tmdbMovieDetails.id |> Num.toStr |> MediaId.fromStr,
    mediaTitle: tmdbMovieDetails.title,
    mediaDescription: tmdbMovieDetails.overview,
    mediaType: Movie,
    mediaPoster: Tmdb.toPosterImageSet tmdbConfig tmdbMovieDetails.posterPath,
    mediaBackdrop: Tmdb.toBackdropImageSet tmdbConfig tmdbMovieDetails.backdropPath,
    mediaVideos: List.map tmdbMovieDetails.videos.results tmdbVideoToMediaVideo,
}

getMovieDetails : Config, MediaId.MediaId -> Task Media [NotFound]
getMovieDetails = \config, mediaId ->
    task =
        req =
            # https://developer.themoviedb.org/reference/movie-details
            "/movie/$(mediaId)"
            |> Url.fromStr
            |> Url.appendParam "append_to_response" "videos"
            |> Url.toStr
            |> \url -> Tmdb.toRequest config url

        res = Http.send! req

        decoded = Json.decode (Str.toUtf8 res)

        when decoded is
            Ok movieDetails ->
                tmdbConfig = Tmdb.getTmdbConfig! config

                media = tmdbMovieDetailsToMedia tmdbConfig movieDetails

                Task.ok media

            Err _ ->
                Task.err NotFound

    task |> Task.onErr (\_ -> Task.err NotFound)

findById : Config -> FindById
findById = \config -> \mediaId, mediaType ->
        when mediaType is
            Movie -> getMovieDetails config mediaId
            Tv -> Task.ok emptyMedia

init : Config -> MediaDb
init = \config -> {
    find: find config,
    findById: findById config,
}
