FROM ghcr.io/gleam-lang/gleam:v1.16.0-erlang

WORKDIR /server

COPY gleam.toml manifest.toml ./
RUN gleam deps download && gleam build

COPY priv/ ./priv/
COPY src/ ./src/

ENTRYPOINT [ "gleam", "run" ]
