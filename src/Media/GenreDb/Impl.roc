module [init, Impl]

import Media.GenreDb as GenreDb
import Media.GenreDb.Impl.Tmdb as Tmdb

Impl : [Tmdb Tmdb.Config]

init : Impl -> GenreDb.GenreDb
init = \impl ->
    when impl is
        Tmdb config ->
            Tmdb.init config
