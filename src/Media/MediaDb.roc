module [MediaDb, MediaQuery, MediaField, FindById, Find]

import pf.Task exposing [Task]
import Query exposing [Query]
import Paginated exposing [Paginated]
import Media exposing [Media]
import MediaId exposing [MediaId]
import MediaType exposing [MediaType]

MediaField : [MediaId, MediaType]

MediaQuery : Query MediaField

Find : Query MediaField -> Task (Paginated Media) []

FindById : MediaId, MediaType -> Task Media [NotFound]

MediaDb : {
    find : Find,
    findById : FindById,
}
