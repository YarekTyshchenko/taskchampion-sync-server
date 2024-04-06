FROM ubuntu:22.04 AS base

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y \
            git \
            curl \
            build-essential

RUN apt clean

# Setup language environment
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Add source directory
#ADD ./taskwarrior/ /opt/taskwarrior
WORKDIR /opt

RUN git clone https://github.com/GothenburgBitFactory/taskwarrior

WORKDIR /opt/taskwarrior/

RUN git fetch origin v3.0.0
RUN git checkout v3.0.0


# Setup Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > rustup.sh && \
    sh rustup.sh -y --profile minimal --default-toolchain stable --component rust-docs

RUN ~/.cargo/bin/cargo build -p taskchampion-sync-server --release
CMD ./target/release/taskchampion-sync-server --port 8443 --data-dir /var/taskwarrior-data
