module [MediaVideo, init, fromUrl, appendParams]

import ImageSet exposing [ImageSet]
import Url exposing [Url]

MediaVideo : {
    id : Str,
    youtubeId : Str,
    youtubeEmbedUrl : Str,
    youtubeWatchUrl : Str,
    thumbnail : ImageSet,
    name : Str,
}

youtubeEmbedUrl : { youtubeId : Str } -> Str
youtubeEmbedUrl = \{ youtubeId } -> "https://www.youtube.com/embed/$(youtubeId)?enablejsapi=1"

youtubeWatchUrl : { youtubeId : Str } -> Str
youtubeWatchUrl = \{ youtubeId } -> "https://www.youtube.com/watch?v=$(youtubeId)"

youtubeThumbnailUrl : Str -> Str
youtubeThumbnailUrl = \youtubeId -> "https://img.youtube.com/vi/$(youtubeId)/hqdefault.jpg"

init : { id : Str, youtubeId : Str, name : Str } -> MediaVideo
init = \{ id, youtubeId, name } -> {
    id: id,
    name: name,
    youtubeId: youtubeId,
    youtubeEmbedUrl: youtubeEmbedUrl { youtubeId },
    youtubeWatchUrl: youtubeWatchUrl { youtubeId },
    thumbnail: ImageSet.init {
        lowestResFirst: [youtubeThumbnailUrl youtubeId],
    },
}

appendParams : Url, MediaVideo -> Url
appendParams = \url, mediaVideo ->
    url
    |> Url.appendParam "mediaVideoId" mediaVideo.id
    |> Url.appendParam "mediaVideoName" mediaVideo.name
    |> Url.appendParam "mediaVideoYoutubeId" mediaVideo.youtubeId

fromUrl : Url -> MediaVideo
fromUrl = \url ->
    queryParams = Url.queryParams url
    id = queryParams |> Dict.get "mediaVideoId" |> Result.withDefault ""
    name = queryParams |> Dict.get "mediaVideoName" |> Result.withDefault ""
    youtubeId = queryParams |> Dict.get "mediaVideoYoutubeId" |> Result.withDefault ""
    init { id, youtubeId, name }
