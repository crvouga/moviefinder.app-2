module [Route, encode, decode]

import MediaId exposing [MediaId]
import MediaType exposing [MediaType]
import Url exposing [Url]
import MediaVideo exposing [MediaVideo]

MediaQuery : { mediaType : MediaType, mediaId : MediaId }

appendParamsMediaQuery : Url, MediaQuery -> Url
appendParamsMediaQuery = \url, { mediaType, mediaId } ->
    url
    |> Url.appendParam "mediaType" (MediaType.toStr mediaType)
    |> Url.appendParam "mediaId" (MediaId.toStr mediaId)

getParamsMediaQuery : Url -> MediaQuery
getParamsMediaQuery = \url ->
    queryParams = Url.queryParams url
    mediaTypeStr = queryParams |> Dict.get "mediaType" |> Result.withDefault ""
    mediaIdStr = queryParams |> Dict.get "mediaId" |> Result.withDefault ""
    mediaType = mediaTypeStr |> MediaType.fromStr
    mediaId = mediaIdStr |> MediaId.fromStr
    { mediaType, mediaId }

Route : [Details MediaQuery, DetailsLoad MediaQuery, Unknown, Video MediaVideo]

encode : Route -> Url
encode = \route ->
    when route is
        DetailsLoad mediaQuery ->
            "/media/details-load"
            |> Url.fromStr
            |> appendParamsMediaQuery mediaQuery

        Details mediaQuery ->
            "/media/details"
            |> Url.fromStr
            |> appendParamsMediaQuery mediaQuery

        Video mediaVideo ->
            "/media/video"
            |> Url.fromStr
            |> MediaVideo.appendParams mediaVideo

        Unknown ->
            Url.fromStr "/"

decode : Url -> Route
decode = \url ->
    when Url.path url is
        "/media/details-load" ->
            mediaQuery = getParamsMediaQuery url
            DetailsLoad mediaQuery

        "/media/details" ->
            mediaQuery = getParamsMediaQuery url
            Details mediaQuery

        "/media/video" ->
            mediaVideo = MediaVideo.fromUrl url
            Video mediaVideo

        _ -> Unknown
