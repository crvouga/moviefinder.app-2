module [init]

import Ctx
import Auth.VerifySms.Impl
import Media.MediaDb.Impl
import Logger
import Request

logger = Logger.init ["app"]

Config a : {
    tmdbApiReadAccessToken : Str,
}a

init : Config *, Request.Request -> Ctx.Ctx
init = \config, req -> {
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
