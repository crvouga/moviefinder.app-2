module [init, Config]

import pf.Task exposing [Task]
import pf.Http
import Media.MediaDb exposing [MediaDb, MediaDbQuery]
import Media exposing [testData]
# import json.Json
import Logger
import pf.Stdout
# import Http.Client

Config : {
    tmdbApiReadAccessToken : Str,
    logger : Logger.Logger,
}

fetchTodos : Config -> Task Str _
fetchTodos = \_config ->
    # Http.Client.get "https://jsonplaceholder.typicode.com/todos/1" Json.utf8
    # |> \t -> Task.attempt t \result -> Task.ok (Inspect.toStr result)
    task =
        response = Http.send! { Http.defaultRequest & url: "https://jsonplaceholder.typicode.com/todos/1" }
        Stdout.line! response
        Task.ok response

    task |> Task.onErr (\_ -> Task.ok "Something went wrong")

fetchAndLogTodos : Config -> Task {} []
fetchAndLogTodos = \config ->
    fetchTodos config
    |> Task.await (\fetched -> Stdout.line fetched)

query : Config -> MediaDbQuery
query = \config -> \_ ->
        _ = fetchAndLogTodos! config
        Task.ok {
            rows: testData,
            limit: 20,
            offset: 0,
            total: 0,
        }

init : Config -> MediaDb
init = \config -> {
    query: query config,
}
