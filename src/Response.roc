module [
    html,
    redirect,
]

import pf.Http exposing [Response]
import Html.Html as Html

html : Html.Node -> Response
html = \body -> {
    status: 200,
    headers: [
        { name: "Content-Type", value: Str.toUtf8 "text/html; charset=utf-8" },
    ],
    body: body |> Html.render |> Str.toUtf8,
}

redirect : Str -> Response
redirect = \location -> {
    status: 302,
    headers: [
        { name: "HX-Redirect", value: Str.toUtf8 location },
    ],
    body: Str.toUtf8 "",
}

# image : Str -> Response
# image = \path -> {
#     status: 200,
#     headers: [
#         { name: "Content-Type", value: "image/png" },
#     ],
#     body: File.read path,
# }
