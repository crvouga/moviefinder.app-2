# Dockerfile

# Builder state using the roclang/nightly-ubuntu-latest image
FROM roclang/nightly-debian-bookworm as builder

# Copy the source code
COPY ./main.roc /src/main.roc

# Build the roc app
RUN ["roc", "build", "/src/main.roc"]

# Check if the binary is present
RUN ["ls", "/src/main"]

# Use a smaller image for running the app
FROM bitnami/minideb:bookworm as final

# Copy the binary from the builder container
COPY --from=builder /src/main .

# Run the app binary
CMD ["./main"]