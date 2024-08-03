module [decodeJsonWithFallback]

import pf.Task exposing [Task]
import json.Json as JsonLib

decodeJsonWithFallback : List U8, val -> Task.Task val [] where val implements Decoding
decodeJsonWithFallback = \json, fallback ->
    decoder = JsonLib.utf8With { fieldNameMapping: SnakeCase }

    decoded = Decode.fromBytesPartial json decoder

    when decoded.result is
        Ok record ->
            Task.ok record

        Err err ->
            when err is
                TooShort ->
                    Task.ok fallback
