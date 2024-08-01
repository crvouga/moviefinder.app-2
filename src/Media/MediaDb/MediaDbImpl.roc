module [init, Impl]

import Media.MediaDb.MediaDb as MediaDb
import Media.MediaDb.MediaDbImpl.TmdbMovie as TmdbMovie

Impl : [TmdbMovie TmdbMovie.Config]

init : Impl -> MediaDb.MediaDb
init = \mediaDbImpl ->
    when mediaDbImpl is
        TmdbMovie config ->
            TmdbMovie.init config
