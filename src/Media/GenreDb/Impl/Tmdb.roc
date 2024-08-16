module [init, Config]

import pf.Task exposing [Task]
import pf.Http
import Media.GenreDb exposing [GenreDb, All]
import json.OptionOrNull exposing [OptionOrNull]
import Logger
import Json
# import Url
import Tmdb
# import Media.Genre exposing [Genre]

Config : {
    tmdbApiReadAccessToken : Str,
    logger : Logger.Logger,
}

Genre : {
    genreId : Str,
    genreName : Str,
}

TmdbGenre : {
    id : OptionOrNull F64,
    name : OptionOrNull Str,
}

tmdbGenreToGenre : TmdbGenre -> Result Genre [MissingData]
tmdbGenreToGenre = \tmdbGenre ->
    result = {
        id: OptionOrNull.getResult tmdbGenre.id,
        name: OptionOrNull.getResult tmdbGenre.name,
    }
    when result is
        { id: Ok id, name: Ok name } ->
            genre : Genre
            genre = { genreId: Num.toStr id, genreName: name }
            Ok genre

        _ ->
            Err MissingData

TmdbGenreResponse : {
    genres : List TmdbGenre,
}

all : Config -> All
all = \config -> \_ ->
        task =
            req =
                # https://developer.themoviedb.org/reference/genre-movie-list
                "/genre/movie/list" # |> Url.fromStr
                |> \url -> Tmdb.toRequest config url

            res = Http.send! req

            decoded : Result TmdbGenreResponse _
            decoded = Json.decode (Str.toUtf8 res)

            when decoded is
                Err _ ->
                    Task.ok []

                Ok value ->
                    genres =
                        value.genres
                        |> List.keepOks tmdbGenreToGenre
                    Task.ok genres

        task |> Task.onErr (\_ -> Task.ok [])

init : Config -> GenreDb
init = \config -> {
    all: all config,
}
