module [Ctx, init]

import Auth.VerifySms
import Media.MediaDb
import Media.MediaDb.Impl
import Logger
import Request
# import KeyValueStore
# import KeyValueStore.Impl

Ctx : {
    verifySms : Auth.VerifySms.VerifySms,
    mediaDb : Media.MediaDb.MediaDb,
    logger : Logger.Logger,
    req : Request.Request,
}

logger = Logger.init ["app"]

init : { tmdbApiReadAccessToken : Str }*, Request.Request -> Ctx
init = \config, req -> {
    verifySms: Auth.VerifySms.init (Fake { code: "123", logger: Logger.init ["verify-sms-fake"] }),
    mediaDb: Media.MediaDb.Impl.init (TmdbMovie { tmdbApiReadAccessToken: config.tmdbApiReadAccessToken, logger: Logger.init ["media-db"] }),
    logger,
    req,
}
