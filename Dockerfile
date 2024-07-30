FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV ROC_VERSION=nightly
ENV ROC_DIR=/opt/roc
ENV PATH="${ROC_DIR}:${PATH}"

RUN apt-get update && apt-get install -y \
    curl \
    tar \
    libc-dev \
    binutils \
    build-essential \
    clang \
    lsb-release \
    file \
    libc6 \
    libstdc++6 \
    && rm -rf /var/lib/apt/lists/*

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

RUN curl -sSL https://ziglang.org/download/0.11.0/zig-linux-x86_64-0.11.0.tar.xz | tar -xJ -C /opt \
    && ln -s /opt/zig-linux-x86_64-0.11.0/zig /usr/local/bin/zig

RUN mkdir -p ${ROC_DIR} \
    && curl -L https://github.com/roc-lang/roc/releases/download/nightly/roc_nightly-linux_x86_64-latest.tar.gz | tar xz -C ${ROC_DIR} --strip-components=1

RUN lsb_release -a && \
    uname -a && \
    file ${ROC_DIR}/roc && \
    ldd ${ROC_DIR}/roc || true

RUN ls -l /lib64/ld-linux-x86-64.so.2 || echo "ld-linux-x86-64.so.2 not found"
RUN ls -l /lib/x86_64-linux-gnu/ld-linux-x86-64.so.2 || echo "ld-linux-x86-64.so.2 not found in alternative location"

RUN ${ROC_DIR}/roc version || echo "Roc version command failed"

WORKDIR /app

CMD ["roc", "run", "src/Main.roc"]