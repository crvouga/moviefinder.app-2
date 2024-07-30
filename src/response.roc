module [
    html,
]

import pf.Http exposing [Response]
import Html.Html as Html

html : Html.Node -> Response
html = \body -> {
    status: 200,
    headers: [],
    body: body |> Html.render |> Str.toUtf8,
}
