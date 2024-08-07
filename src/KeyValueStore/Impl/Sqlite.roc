# https://github.com/roc-lang/basic-webserver/tree/main/examples
# https://roc-lang.github.io/basic-webserver/SQLite3/
module [init, Config]

import pf.Task
import pf.SQLite3
import KeyValueStore
import Logger exposing [Logger]
import pf.Stdout

Config : {
    databaseUrl : Str,
    logger : Logger,
}

removeSqlitePrefix : Str -> Str
removeSqlitePrefix = \str ->
    Str.replaceFirst str "sqlite:" " " |> Str.trim

expect
    removeSqlitePrefix "sqlite:db/database.sqlite3" == "db/database.sqlite3"

get : Config, Str -> Task.Task Str [NotFound, Errored Str]
get = \config, key ->
    # Logger.info! config.logger "Getting key: $(key)"
    Stdout.line! "Getting key: $(key) $(config.databaseUrl)"

    executed <-
        SQLite3.execute {
            path: removeSqlitePrefix config.databaseUrl,
            query: "SELECT key, value FROM key_value WHERE key = :key;",
            bindings: [{ name: ":key", value: key }],
        }
        |> Task.attempt

    when executed is
        Err err -> Task.err (Errored (SQLite3.errToStr err))
        Ok rows ->
            firstRow = List.first rows
            when firstRow is
                Err _ -> Task.err NotFound
                Ok row ->
                    firstColumn = List.first row
                    when firstColumn is
                        Err _ -> Task.err (Errored "No value")
                        Ok columnValue ->
                            when columnValue is
                                String columnValueStr -> Task.ok columnValueStr
                                _ -> Task.err (Errored "No value")

set : Config, Str, Str -> Task.Task {} [Errored Str]
set = \config, key, value ->
    executed <- SQLite3.execute {
            path: config.databaseUrl,
            query: "INSERT INTO key_value(key, value) VALUES (:key, :value)",
            bindings: [{ name: ":key", value: key }, { name: ":value", value: value }],
        }
        |> Task.attempt

    when executed is
        Ok _ -> Task.ok {}
        Err err -> Task.err (Errored (SQLite3.errToStr err))

init : Config -> KeyValueStore.KeyValueStore
init = \config -> {
    get: \key -> get config key,
    set: \key, value -> set config key value,
}
