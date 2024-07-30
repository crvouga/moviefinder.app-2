# Makefile

# Image name
IMAGE_NAME = roc-app

# Build the Docker image
build:
	docker build --platform linux/amd64 -t $(IMAGE_NAME) .

# Run the Docker container
run:
	docker run --platform linux/amd64 --rm $(IMAGE_NAME)