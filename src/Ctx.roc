module [Ctx, init]

import Auth.VerifySms.VerifySms as VerifySms
import Auth.VerifySms.VerifySmsImpl as VerifySmsImpl
import Media.MediaDb.MediaDb as MediaDb
import Media.MediaDb.MediaDbImpl as MediaDbImpl
import Logger

Ctx : {
    verifySms : VerifySms.VerifySms,
    mediaDb : MediaDb.MediaDb,
    logger : Logger.Logger,
}

logger = Logger.init ["app"]

init : Ctx
init = {
    verifySms: VerifySmsImpl.init (Fake { code: "123", logger: Logger.init ["verify-sms-fake"] }),
    mediaDb: MediaDbImpl.init (TmdbMovie { tmdbApiReadAccessToken: "123" }),
    logger,
}
