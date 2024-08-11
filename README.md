# moviefinder.app

## Run

```sh
chmod +x ./run
./run
```

## Database Migrations

```sh
npx dbmate --help
```

## Build Docker

```sh
docker build --platform linux/amd64 -t moviefinder-app .
```

## Run Docker

```sh
export $(grep -v '^#' .env | xargs) && docker run --platform linux/amd64 --rm -e DATABASE_URL="$DATABASE_URL" moviefinder-app
```
