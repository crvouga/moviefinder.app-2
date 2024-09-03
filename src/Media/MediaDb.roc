module [MediaDb, MediaQuery, MediaField, FindById, Find]

import Query exposing [Query]
import Paginated exposing [Paginated]
import Media.Media exposing [Media]
import Media.MediaId exposing [MediaId]
import Media.MediaType exposing [MediaType]

MediaField : [MediaId, MediaType]

MediaQuery : Query MediaField

Find : Query MediaField -> Task (Paginated Media) []

FindById : MediaId, MediaType -> Task Media [NotFound]

MediaDb : {
    find : Find,
    findById : FindById,
}
