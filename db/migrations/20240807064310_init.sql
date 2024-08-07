-- migrate:up

CREATE TABLE key_value (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL
)

-- migrate:down

DROP TABLE key_value
