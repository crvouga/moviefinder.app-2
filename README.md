# moviefinder.app

## Run

```sh
chmod +x ./run
./run
```

## Build Docker

```sh
docker build --platform linux/amd64 -t moviefinder-app .
```

## Run Docker

```sh
docker run --platform linux/amd64 --rm moviefinder-app
```
