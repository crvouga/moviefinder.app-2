module [ImageSet, highestRes, init, mediumRes, lowestRes, empty]

ImageSet := List Str

empty : ImageSet
empty = @ImageSet []

init : { lowestResFirst ? List Str } -> ImageSet
init = \{ lowestResFirst ? [] } -> @ImageSet lowestResFirst

highestRes : ImageSet -> Str
highestRes = \@ImageSet imageSet -> List.last imageSet |> Result.withDefault ""

mediumRes : ImageSet -> Str
mediumRes = \@ImageSet imageSet ->
    middleIndex = List.len imageSet // 2
    imageSet |> List.get middleIndex |> Result.withDefault ""

lowestRes : ImageSet -> Str
lowestRes = \@ImageSet imageSet -> List.first imageSet |> Result.withDefault ""

