module [Media]

import ImageSet
import MediaId
import MediaType

Media : {
    mediaId : MediaId.MediaId,
    mediaTitle : Str,
    mediaDescription : Str,
    mediaType : MediaType.MediaType,
    mediaPoster : ImageSet.ImageSet,
}
