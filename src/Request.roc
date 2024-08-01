module [Request, fromHttp]

import Route
import pf.Http

Request : {
    route : Route.Route,
}

fromHttp : Http.Request -> Request
fromHttp = \httpReq -> {
    route: Route.decode httpReq.url,
}
