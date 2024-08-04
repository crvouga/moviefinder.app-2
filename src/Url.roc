module [Url, fromStr, toStr, path, appendParam, queryParams]

import pf.Url as UrlLib

Url := UrlLib.Url

fromStr : Str -> Url
fromStr = \str -> @Url (UrlLib.fromStr str)

toStr : Url -> Str
toStr = \@Url url -> UrlLib.toStr url

path : Url -> Str
path = \@Url url -> UrlLib.path url

appendParam : Url, Str, Str -> Url
appendParam = \@Url url, key, value -> @Url (UrlLib.appendParam url key value)

queryParams : Url -> Dict Str Str
queryParams = \@Url url -> UrlLib.queryParams url
