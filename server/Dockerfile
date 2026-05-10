FROM midnight_domain

WORKDIR /server

COPY gleam.toml manifest.toml ./
RUN gleam deps download

COPY priv/ ./priv/
COPY src/ ./src/
RUN gleam build

ENTRYPOINT [ "gleam", "run" ]
