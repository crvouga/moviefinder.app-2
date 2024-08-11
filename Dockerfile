# Builder state using the roclang/nightly-ubuntu-latest image
FROM roclang/nightly-debian-bookworm as builder
# Copy the source code
COPY ./src /src
# Build the roc app
RUN ["roc", "build", "--optimize", "/src/Main.roc"]
# Check if the binary is present
RUN ["ls", "/src/Main"]

# Use a smaller image for running the app
FROM bitnami/minideb:bookworm as final
# Set environment variables
ENV ROC_BASIC_WEBSERVER_HOST=0.0.0.0
ENV ROC_BASIC_WEBSERVER_PORT=8000
ENV DATABASE_URL="sqlite:data/database.sqlite3"

# Install dbmate
RUN apt-get update && apt-get install -y curl \
    && curl -fsSL -o /usr/local/bin/dbmate https://github.com/amacneil/dbmate/releases/latest/download/dbmate-linux-amd64 \
    && chmod +x /usr/local/bin/dbmate

# Copy the binary from the builder container
COPY --from=builder /src/Main .

# Copy database migration files (assuming they're in a 'db' directory)
COPY ./db /db

# Create the data directory to avoid "unable to open database file" errors
RUN mkdir -p data

# Run dbmate up and then execute Main
CMD dbmate up && ./Main
