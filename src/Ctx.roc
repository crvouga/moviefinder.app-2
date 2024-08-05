module [Ctx]

import Auth.VerifySms
import Media.MediaDb
import Logger
import Request

Ctx : {
    verifySms : Auth.VerifySms.VerifySms,
    mediaDb : Media.MediaDb.MediaDb,
    logger : Logger.Logger,
    req : Request.Request,
}
