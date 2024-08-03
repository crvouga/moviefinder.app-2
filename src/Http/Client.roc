module [
    get,
]
import pf.Task exposing [Task]
import pf.Http exposing [send, defaultRequest]

## Try to perform an HTTP get request and convert (decode) the received bytes into a Roc type.
## Very useful for working with Json.
##
## ```
## import json.Json
##
## # On the server side we send `Encode.toBytes {foo: "Hello Json!"} Json.utf8`
## { foo } = Http.get! "http://localhost:8000" Json.utf8
## ```
get : Str, fmt -> Task body [HttpErr Http.Error, HttpDecodingFailed] where body implements Decoding, fmt implements DecoderFormatting
get = \url, fmt ->
    task =
        response = send! { defaultRequest & url }

        Decode.fromBytes (Str.toUtf8 response) fmt
        |> Result.mapErr \_ -> HttpDecodingFailed
        |> Task.fromResult

    task
    |> Task.onErr
        (\err -> Task.err
                (
                    when err is
                        HttpDecodingFailed -> HttpDecodingFailed
                        _ -> HttpErr Timeout
                )
        )
