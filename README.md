# ASCII Canvas Exercise

This project aims to solve the exercise of creating a client-server system that represents ASCII art drawing canvas (documented in [task.md](./task.md)). It is written in Elixir, uses Phoenix on the backend and PostgreSQL database.

It is divided into two parts:

1. the `Asciicanvas` module which is used for parsing draw commands and creating the ASCII art
2. the `CanvasServer` Phoenix server which implements the draw module, offers RESTful JSON API and a simple read-only client interface with web sockets for live refresh

## Setup

### With docker (recommended)

- Make `run.sh` executable with `chmod +x run.sh`
- Spin up the service with PostgreSQL database with `docker-compose up`.
- wait until you see a successful message: `[info] Access CanvasServerWeb.Endpoint at http://localhost:4000`.

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

### Manual

- Follow [Elixir's setup guide](https://elixir-lang.org/install.html), install version Elixir 1.9+ & Erlang 22
- Follow latest [Phoenix's setup guide](https://hexdocs.pm/phoenix/installation.html)
- Install [Node.js](https://nodejs.org/en/)
- Install and setup [PostgreSQL](https://wiki.postgresql.org/wiki/Detailed_installation_guides)
- (Linux only) install additional [inotify-tool](https://github.com/inotify-tools/inotify-tools/wiki) for live reload functionality

To start the Phoenix server:

- Make sure PostgreSQL is running
- Navigate to `canvas_server` directory
- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Install Node.js dependencies with `npm install` inside the `assets` directory
- Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Create a ASCII drawing

```bash
# POST /api/drawings { operations: string[] }
$ curl -X POST \
   -H "Content-Type: application/json"  \
   -d '{ "operations": [ "Rectangle at [3,2] with width: 5, height: 3, outline character: `@`, fill character: `X`", "Flood fill at `[0, 0]` with fill character `-` (canvas presented in 32x12 size)", "- Rectangle at `[5, 5]` with width `5`, height `3`, outline character: `#`, fill: `none`" ] }' \
   http://localhost:4000/api/drawings
```

Supported draw commands are documented in `task.md` file.

## Testing

Navigate to `asciicanvas` or `canvas_server` directories and use `mix test` to run unit and integration tests.

If setup with Docker was used, first open the container shell with `docker-compose run web sh`, navigate to the specific folder and use `mix test`. Note that tests are automatically executed on every startup with `docker-compose`.
