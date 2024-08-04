module [MediaDb, MediaDbQuery, MediaQuery, MediaField, MediaDbFindById]

import pf.Task exposing [Task]
import Query exposing [Query]
import Paginated exposing [Paginated]
import Media exposing [Media]
import MediaId exposing [MediaId]
import MediaType exposing [MediaType]

MediaField : [MediaId, MediaType]

MediaQuery : Query MediaField

MediaDbQuery : Query MediaField -> Task (Paginated Media) []

MediaDbFindById : MediaId, MediaType -> Task Media [NotFound]

MediaDb : {
    query : MediaDbQuery,
    findById : MediaDbFindById,
}
