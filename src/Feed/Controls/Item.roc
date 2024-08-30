module [Item, itemGenre, encode]

import Media.Genre exposing [Genre]
import Json
import Base64

Item : [ItemGenre Genre]

itemGenre : Genre -> Item
itemGenre = \genre -> ItemGenre genre

encode : Item -> Str
encode = \item ->
    Json.encode item |> Str.fromUtf8 |> Result.withDefault "" |> Base64.encode

