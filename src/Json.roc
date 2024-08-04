# https://lukewilliamboswell.github.io/roc-json/
module [decodeWithFallback, encode]

import json.Json as JsonLib

decodeWithFallback : List U8, val -> val where val implements Decoding
decodeWithFallback = \json, fallback ->
    decoder = JsonLib.utf8With {
        fieldNameMapping: SnakeCase,
    }

    decoded = Decode.fromBytesPartial json decoder

    when decoded.result is
        Ok record ->
            record

        Err err ->
            when err is
                TooShort ->
                    fallback

encode : val -> List U8 where val implements Encoding
encode = \val ->
    val |> Encode.toBytes JsonLib.utf8
