FROM ghcr.io/gleam-lang/gleam:v1.16.0-erlang

WORKDIR /app

COPY gleam.toml manifest.toml ./
COPY src/ ./src/

RUN gleam deps download \
    && gleam build

CMD [ "gleam", "run", "-m", "lustre/dev", "start", "--host=0.0.0.0" ]
