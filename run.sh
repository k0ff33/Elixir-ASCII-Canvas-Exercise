#!/bin/sh
# Adapted from https://github.com/dogweather/phoenix-docker-compose/blob/master/run.sh# https://medium.com/@hex337/running-a-phoenix-1-3-project-with-docker-compose-d82ab55e43cf

set -e

# move to Phoenix server directory
cd canvas_server

# Ensure the app's dependencies are installed
mix deps.get

# Install JS libraries
echo "\nInstalling JS..."
cd assets && npm install
cd ..

# Wait for Postgres to become available.
until PGPASSWORD=postgres psql -h db -U "postgres" -c '\q' 2>/dev/null; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

echo "\nPostgres is available: continuing with database setup..."

# Potentially Set up the database
mix ecto.create
mix ecto.migrate

echo "\nTesting the installation..."
# "Prove" that install was successful by running the tests
mix test

echo "\n Launching Phoenix web server..."
# Start the phoenix web server
mix phx.server