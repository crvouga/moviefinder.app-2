module [init, Config, getDiscoverMovie]

import pf.Task exposing [Task]
import pf.Http
import Media.MediaDb exposing [MediaDb, MediaDbQuery, MediaDbFindById, MediaQuery]
import Media exposing [Media]
import Logger
import Media.MediaDb.Impl.Tmdb as Tmdb
import Json
import ImageSet
import MediaId
# import MediaType
import MediaVideo
import Url
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

toBackdropImageSet : Tmdb.TmdbConfig, Str -> ImageSet.ImageSet
toBackdropImageSet = \tmdbConfig, backdropPath ->
    tmdbConfig.images.backdropSizes
    |> List.map \size -> [tmdbConfig.images.baseUrl, size, backdropPath] |> Str.joinWith ""
    |> \lowestResFirst -> ImageSet.init { lowestResFirst }

tmdbMovieToMedia : Tmdb.TmdbConfig, TmdbDiscoverMovieResult -> Media
tmdbMovieToMedia = \tmdbConfig, tmdbMovie -> {
    mediaId: tmdbMovie.id |> Num.toStr |> MediaId.fromStr,
    mediaTitle: tmdbMovie.title,
    mediaDescription: tmdbMovie.overview,
    mediaType: Movie,
    mediaPoster: toPosterImageSet tmdbConfig tmdbMovie.posterPath,
    mediaBackdrop: toBackdropImageSet tmdbConfig tmdbMovie.backdropPath,
    mediaVideos: [],
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
    mediaPoster: toPosterImageSet tmdbConfig tmdbMovieDetails.posterPath,
    mediaBackdrop: toBackdropImageSet tmdbConfig tmdbMovieDetails.backdropPath,
    mediaVideos: List.map tmdbMovieDetails.videos.results tmdbVideoToMediaVideo,
}

getMovieDetails : Config, MediaId.MediaId -> Task Media [NotFound]
getMovieDetails = \config, mediaId ->
    task =
        url =
            # https://developer.themoviedb.org/reference/movie-details
            "/movie/$(mediaId)"
            |> Url.fromStr
            |> Url.appendParam "append_to_response" "videos"
            |> Url.toStr

        response = Http.send! (Tmdb.toRequest config url)

        decoded = Json.decode (Str.toUtf8 response)
        Stdout.line! (if Bool.false then Inspect.toStr decoded else "")

        when decoded is
            Ok movieDetails ->
                tmdbConfig = Tmdb.getTmdbConfig! config

                media = tmdbMovieDetailsToMedia tmdbConfig movieDetails

                Task.ok media

            Err _ ->
                Task.err NotFound

    task |> Task.onErr (\_ -> Task.err NotFound)

findById : Config -> MediaDbFindById
findById = \config -> \mediaId, mediaType ->
        when mediaType is
            Movie -> getMovieDetails config mediaId
            Tv -> Task.ok emptyMedia

init : Config -> MediaDb
init = \config -> {
    query: query config,
    findById: findById config,
}
