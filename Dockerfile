FROM elixir:latest

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    curl \
    git \
    build-essential

# Install Rust non-interactively
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Install Gleam
RUN mkdir -p /opt/gleam && \
    cd /opt/ && \
    git clone https://github.com/gleam-lang/gleam.git --branch main && \
    cd gleam && \
    export PATH=~/.cargo/bin:$PATH && \
    make install

RUN cp ~/.cargo/bin/gleam /usr/local/bin/gleam

# Create a non-root user
RUN useradd -ms /bin/bash appuser

# Create app and data directories and set permissions
RUN mkdir -p /app && chown appuser:appuser /app
RUN mkdir -p /data && chown appuser:appuser /data

USER appuser
# Verify the compiler is installed for this user
RUN . ~/.bashrc && gleam --version

# Add a line to .bashrc to change the working directory to /app
RUN echo "cd /app" >> ~/.bashrc

WORKDIR /app
