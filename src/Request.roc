module [Request, fromHttp]

import Route
import pf.Http
import Url

Request : {
    route : Route.Route,
    formData : Dict Str Str,
}

toContentType : Http.Request -> Str
toContentType = \httpReq ->
    httpReq
    |> .headers
    |> List.findFirst \h -> h.name == "content-type"
    |> Result.map (\h -> h.value |> Str.fromUtf8 |> Result.withDefault "")
    |> Result.withDefault ""

parseFormUrlEncoded : Str -> Dict Str Str
parseFormUrlEncoded = \str ->
    str
    |> Str.split "&"
    |> List.map (\pair -> pair |> Str.split "=")
    |> List.map
        (\entry ->
            when entry is
                [key, value] -> (key, value)
                _ -> ("", "")
        )
    |> List.dropIf (\(key, _) -> key == "")
    |> Dict.fromList

expect
    (parseFormUrlEncoded "a=1&b=2") == Dict.fromList [("a", "1"), ("b", "2")]

toFormData : Http.Request -> Dict Str Str
toFormData = \httpReq ->
    contentType = toContentType httpReq
    when contentType is
        "application/x-www-form-urlencoded" -> httpReq.body |> Str.fromUtf8 |> Result.withDefault "" |> parseFormUrlEncoded
        _ -> Dict.empty {}

fromHttp : Http.Request -> Request
fromHttp = \httpReq -> {
    route: httpReq.url |> Url.fromStr |> Route.decode,
    formData: toFormData httpReq,
}
