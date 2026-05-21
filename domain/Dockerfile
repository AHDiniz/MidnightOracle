FROM ghcr.io/gleam-lang/gleam:v1.16.0-erlang

WORKDIR /domain

COPY gleam.toml manifest.toml ./
RUN gleam deps download

COPY src/ src/

ENTRYPOINT [ "gleam" ]
