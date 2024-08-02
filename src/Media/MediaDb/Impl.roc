module [init, Impl]

import Media.MediaDb as MediaDb
import Media.MediaDb.Impl.TmdbMovie as TmdbMovie

Impl : [TmdbMovie TmdbMovie.Config]

init : Impl -> MediaDb.MediaDb
init = \mediaDbImpl ->
    when mediaDbImpl is
        TmdbMovie config ->
            TmdbMovie.init config
