module [Ctx, init]

import Auth.VerifySms
import Auth.VerifySms.Impl
import Media.MediaDb
import Media.MediaDb.Impl
import Logger

Ctx : {
    verifySms : Auth.VerifySms.VerifySms,
    mediaDb : Media.MediaDb.MediaDb,
    logger : Logger.Logger,
}

logger = Logger.init ["app"]

init : Ctx
init = {
    verifySms: Auth.VerifySms.Impl.init (Fake { code: "123", logger: Logger.init ["verify-sms-fake"] }),
    mediaDb: Media.MediaDb.Impl.init (TmdbMovie { tmdbApiReadAccessToken: "123", logger: Logger.init ["media-db"] }),
    logger,
}
