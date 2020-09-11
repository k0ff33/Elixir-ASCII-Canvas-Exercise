FROM elixir:1.9

# Install debian packages
RUN apt-get update
RUN apt-get install --yes build-essential inotify-tools postgresql-client

# Install Phoenix packages
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install --force hex phx_new 1.5.4

# Install node
RUN apt-get install --yes nodejs npm

WORKDIR /app
EXPOSE 4000