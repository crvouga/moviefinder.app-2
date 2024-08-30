module [Media]

import ImageSet
import Media.MediaId as MediaId
import Media.MediaType as MediaType
import Media.MediaVideo as MediaVideo

Media : {
    mediaId : MediaId.MediaId,
    mediaTitle : Str,
    mediaDescription : Str,
    mediaType : MediaType.MediaType,
    mediaPoster : ImageSet.ImageSet,
    mediaBackdrop : ImageSet.ImageSet,
    mediaVideos : List MediaVideo.MediaVideo,
}

