module [MediaDb, MediaDbQuery, MediaField]

import pf.Task exposing [Task]
import Query exposing [Query]
import Paginated exposing [Paginated]
import Media exposing [Media]

MediaField : [MediaId]

MediaDbQuery : Query MediaField -> Task (Paginated Media) []

MediaDb : {
    query : MediaDbQuery,
}
