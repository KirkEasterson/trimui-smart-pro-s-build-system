FROM debian:bookworm-20251208-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    build-essential \
    ca-certificates \
    libstdc++6 \
    gcc \
    make \
    wget \
    tar \
    libssl-dev \
    file \
    curl

WORKDIR /sdk

RUN wget -q https://github.com/trimui/toolchain_sdk_smartpro_s/releases/download/20251208/sdk_tg5050_linux_v1.0.0.tgz  && \
    tar -xzf sdk_tg5050_linux_v1.0.0.tgz -C /sdk && \
    rm sdk_tg5050_linux_v1.0.0.tgz

ENV PATH="/sdk/sdk_tg5050_linux_v1.0.0/host/sdk_tg5050_linux_v1.0.0/bin:$PATH"

ENV SYSROOT="/sdk/sdk_tg5050_linux_v1.0.0/host/usr"
ENV SDL_DIR="/sdk/sdk_tg5050_linux_v1.0.0/host/aarch64-buildroot-linux-gnu/sysroot/usr/include/SDL2"

WORKDIR /app

CMD ["/bin/bash"]
