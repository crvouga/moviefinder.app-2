module [Route, encode, decode, DetailsQuery]

import MediaId exposing [MediaId]
import MediaType exposing [MediaType]
import Url exposing [Url]
import MediaVideo exposing [MediaVideo]

DetailsQuery : {
    mediaType : MediaType,
    mediaId : MediaId,
    titleLen : U64,
    descriptionLen : U64,
}

appendParamsDetailsQuery : Url, DetailsQuery -> Url
appendParamsDetailsQuery = \url, { mediaType, mediaId, titleLen, descriptionLen } ->
    url
    |> Url.appendParam "mediaType" (MediaType.toStr mediaType)
    |> Url.appendParam "mediaId" (MediaId.toStr mediaId)
    |> Url.appendParam "titleLen" (Num.toStr titleLen)
    |> Url.appendParam "descriptionLen" (Num.toStr descriptionLen)

getParamsDetailsQuery : Url -> DetailsQuery
getParamsDetailsQuery = \url ->
    queryParams = Url.queryParams url
    mediaTypeStr = queryParams |> Dict.get "mediaType" |> Result.withDefault ""
    mediaIdStr = queryParams |> Dict.get "mediaId" |> Result.withDefault ""
    mediaType = mediaTypeStr |> MediaType.fromStr
    mediaId = mediaIdStr |> MediaId.fromStr
    titleLen = queryParams |> Dict.get "titleLen" |> Result.withDefault "" |> Str.toU64 |> Result.withDefault 12
    descriptionLen = queryParams |> Dict.get "descriptionLen" |> Result.withDefault "" |> Str.toU64 |> Result.withDefault 144
    { mediaType, mediaId, titleLen, descriptionLen }

Route : [Details DetailsQuery, DetailsLoad DetailsQuery, Unknown, Video MediaVideo]

encode : Route -> Url
encode = \route ->
    when route is
        DetailsLoad detailsQuery ->
            "/media/details-load"
            |> Url.fromStr
            |> appendParamsDetailsQuery detailsQuery

        Details detailsQuery ->
            "/media/details"
            |> Url.fromStr
            |> appendParamsDetailsQuery detailsQuery

        Video mediaVideo ->
            "/media/video"
            |> Url.fromStr
            |> MediaVideo.appendParams mediaVideo

        Unknown ->
            Url.fromStr "/"

decode : Url -> Route
decode = \url ->
    when Url.toPaths url is
        ["/media", "/details-load"] ->
            detailsQuery = getParamsDetailsQuery url
            DetailsLoad detailsQuery

        ["/media", "/details"] ->
            detailsQuery = getParamsDetailsQuery url
            Details detailsQuery

        ["/media", "/video"] ->
            mediaVideo = MediaVideo.fromUrl url
            Video mediaVideo

        _ -> Unknown
