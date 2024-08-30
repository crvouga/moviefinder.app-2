module [encode, decode]

import base64.Base64 as Base64Lib

encode : Str -> Str
encode = \decoded ->
    decoded
    |> Base64Lib.encodeStr
    |> Str.fromUtf8
    |> Result.withDefault ""

decode : Str -> Str
decode = \encoded ->
    encoded
    |> Base64Lib.decodeStr
    |> Str.fromUtf8
    |> Result.withDefault ""
