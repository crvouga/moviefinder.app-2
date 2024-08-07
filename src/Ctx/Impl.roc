module [init]

import Ctx
import Auth.VerifySms.Impl
import Media.MediaDb.Impl
import KeyValueStore.Impl
import Logger
import Request

logger = Logger.init ["app"]

Config : {
    tmdbApiReadAccessToken : Str,
    sqlitePath : Str,
}

init : Config, Request.Request -> Ctx.Ctx
init = \config, req -> {
    keyValueStore: KeyValueStore.Impl.init (Sqlite { sqlitePath: config.sqlitePath, logger: Logger.init ["key-value-store", "sqlite"] }),
    verifySms: Auth.VerifySms.Impl.init
        (
            Fake {
                code: "123",
                logger: Logger.init ["verify-sms-fake"],
            }
        ),
    mediaDb: Media.MediaDb.Impl.init
        (
            TmdbMovie {
                tmdbApiReadAccessToken: config.tmdbApiReadAccessToken,
                logger: Logger.init ["media-db"],
            }
        ),
    logger,
    req,
}
