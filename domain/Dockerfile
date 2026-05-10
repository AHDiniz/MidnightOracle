FROM ghcr.io/gleam-lang/gleam:v1.16.0-erlang

WORKDIR /domain
COPY gleam.toml manifest.toml ./
COPY src/ src/

RUN gleam deps download

ENTRYPOINT [ "gleam", "run" ]
