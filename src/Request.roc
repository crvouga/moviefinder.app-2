module [Request, fromHttp]

import Route
import pf.Http
import Url

Request : {
    route : Route.Route,
}

fromHttp : Http.Request -> Request
fromHttp = \httpReq -> {
    route: httpReq.url |> Url.fromStr |> Route.decode,
}
