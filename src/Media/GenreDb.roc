module [GenreDb, All]

import Media.Genre exposing [Genre]

All : {} -> Task (List Genre) []

GenreDb : {
    all : All,
}
