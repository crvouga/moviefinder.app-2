module [MediaDb, MediaDbQuery, MediaQuery, MediaField]

import pf.Task exposing [Task]
import Query exposing [Query]
import Paginated exposing [Paginated]
import Media exposing [Media]

MediaField : [MediaId]

MediaQuery : Query MediaField

MediaDbQuery : Query MediaField -> Task (Paginated Media) []

MediaDb : {
    query : MediaDbQuery,
}
