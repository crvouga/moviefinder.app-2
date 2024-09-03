module [Item, itemGenre, encode, chipLabel]

import Media.Genre exposing [Genre]
import Json
import Base64

Item : [ItemGenre Genre]

chipLabel : Item -> Str
chipLabel = \item ->
    when item is
        ItemGenre genre -> genre.genreName

itemGenre : Genre -> Item
itemGenre = \genre -> ItemGenre genre

encode : Item -> Str
encode = \item ->
    Json.encode item |> Str.fromUtf8 |> Result.withDefault "" |> Base64.encode

