FROM midnight_domain

WORKDIR /app

COPY gleam.toml manifest.toml ./
RUN gleam deps download

COPY src/ ./src/
RUN gleam build

CMD [ "gleam", "run", "-m", "lustre/dev", "start", "--host=0.0.0.0" ]
