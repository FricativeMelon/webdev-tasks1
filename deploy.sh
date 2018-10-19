#!/bin/bash

export MIX_ENV=prod
export PORT=4747
export NODEBIN=`pwd`/assets/node_modules/.bin
export PATH="$PATH:$NODEBIN"

echo "Building..."

mix deps.get --only prod
MIX_ENV=prod mix compile

mix compile
(cd assets && npm install)
(cd assets && webpack --mode production)
mix phx.digest

MIX_ENV=prod mix ecto.migrate

echo "Generating release..."
mix release --env=prod

#echo "Stopping old copy of app, if any..."
#_build/prod/rel/draw/bin/practice stop || true

echo "Starting app..."

_build/prod/rel/tasktracker/bin/tasktracker foreground

