module [FeedDb, Get, Put]

import Feed.Feed exposing [Feed]
import Feed.FeedId exposing [FeedId]

Get : FeedId -> Task Feed [NotFound]

Put : Feed -> Task {} [Errored Str]

FeedDb : {
    get : Get,
    put : Put,
}
