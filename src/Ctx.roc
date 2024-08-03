module [Ctx, init]

import Auth.VerifySms
import Auth.VerifySms.Impl
import Media.MediaDb
import Media.MediaDb.Impl
import Logger
# import KeyValueStore
# import KeyValueStore.Impl

Ctx : {
    verifySms : Auth.VerifySms.VerifySms,
    mediaDb : Media.MediaDb.MediaDb,
    logger : Logger.Logger,
}

logger = Logger.init ["app"]

init : { tmdbApiReadAccessToken : Str }* -> Ctx
init = \config -> {
    verifySms: Auth.VerifySms.Impl.init (Fake { code: "123", logger: Logger.init ["verify-sms-fake"] }),
    mediaDb: Media.MediaDb.Impl.init (TmdbMovie { tmdbApiReadAccessToken: config.tmdbApiReadAccessToken, logger: Logger.init ["media-db"] }),
    logger,
}
