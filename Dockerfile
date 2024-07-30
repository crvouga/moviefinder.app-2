# Builder state using the roclang/nightly-ubuntu-latest image
FROM roclang/nightly-debian-bookworm as builder

# Copy the source code
COPY ./src /src

# Build the roc app
RUN ["roc", "build", "/src/Main.roc"]

# Check if the binary is present
RUN ["ls", "/src/Main"]

# Use a smaller image for running the app
FROM bitnami/minideb:bookworm as final

# Set environment variables
ENV ROC_BASIC_WEBSERVER_HOST=0.0.0.0
ENV ROC_BASIC_WEBSERVER_PORT=8000

# Copy the binary from the builder container
COPY --from=builder /src/Main .

# Run the app binary
CMD ["./Main"]