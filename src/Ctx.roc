module [Ctx, init]

import Auth.VerifySms.VerifySms as VerifySms
import Auth.VerifySms.VerifySmsImpl as VerifySmsImpl
import Media.MediaDb.MediaDb as MediaDb
import Media.MediaDb.MediaDbImpl as MediaDbImpl

Ctx : {
    verifySms : VerifySms.VerifySms,
    mediaDb : MediaDb.MediaDb,
}

init : Ctx
init = {
    verifySms: VerifySmsImpl.init (Fake { code: "123" }),
    mediaDb: MediaDbImpl.init (TmdbMovie { tmdbApiReadAccessToken: "123" }),
}
