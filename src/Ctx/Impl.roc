module [init]

import Ctx
import Auth.VerifySms.Impl
import Media.MediaDb.Impl
import KeyValueStore.Impl
import Logger
import Feed.FeedDb.Impl
import Request

logger = Logger.init ["app"]

init :
    {
        tmdbApiReadAccessToken : Str,
        databaseUrl : Str,
        req : Request.Request,
    }*
    -> Ctx.Ctx
init = \config -> {
    keyValueStore: KeyValueStore.Impl.init (Sqlite { databaseUrl: config.databaseUrl, logger: Logger.init ["key-value-store", "sqlite"] }),
    feedDb: Feed.FeedDb.Impl.init
        (
            KeyValueStore {
                keyValueStore: KeyValueStore.Impl.init (Sqlite { databaseUrl: config.databaseUrl, logger: Logger.init ["key-value-store", "sqlite"] }),
            }
        ),
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
    req: config.req,
}
