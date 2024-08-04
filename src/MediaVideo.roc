module [MediaVideo, init]

import ImageSet

MediaVideo : {
    id : Str,
    youtubeId : Str,
    youtubeEmbedUrl : Str,
    youtubeWatchUrl : Str,
    thumbnail : ImageSet.ImageSet,
    name : Str,
}

youtubeEmbedUrl : { youtubeId : Str } -> Str
youtubeEmbedUrl = \{ youtubeId } -> "https://www.youtube.com/embed/$(youtubeId)"

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
