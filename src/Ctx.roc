module [Ctx]

import Auth.VerifySms
import Media.MediaDb
import Logger
import KeyValueStore
import Request
import Feed.FeedDb

Ctx : {
    verifySms : Auth.VerifySms.VerifySms,
    feedDb : Feed.FeedDb.FeedDb,
    mediaDb : Media.MediaDb.MediaDb,
    logger : Logger.Logger,
    req : Request.Request,
    keyValueStore : KeyValueStore.KeyValueStore,
}
