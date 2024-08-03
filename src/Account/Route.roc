module [Route, encode, decode]

Route : [Account]

encode : Route -> Str
encode = \route ->
    when route is
        Account -> "/account"

decode : Str -> Route
decode = \str ->
    when str is
        "/account" -> Account
        _ -> Account
