module [MediaDb]

import pf.Task exposing [Task]
import Query exposing [Query]
import Paginated exposing [Paginated]
import Media.Media exposing [Media]

MediaField : [MediaId]

MediaDb : {
    query : Query MediaField -> Task (Paginated Media) [],
}
