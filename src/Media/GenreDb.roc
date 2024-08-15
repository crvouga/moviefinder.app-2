module [GenreDb, All]

import pf.Task exposing [Task]
import Media.Genre exposing [Genre]

All : {} -> Task (List Genre) []

GenreDb : {
    all : All,
}
