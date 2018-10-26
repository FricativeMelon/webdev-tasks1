#!/bin/bash

export MIX_ENV=dev
export PORT=4748
export NODEBIN=`pwd`/assets/node_modules/.bin
export PATH="$PATH:$NODEBIN"

echo "Building..."

mix deps.get
MIX_ENV=dev mix compile

mix compile
(cd assets && npm install && webpack --mode production)
mix phx.digest

MIX_ENV=dev mix ecto.migrate

echo "Generating release..."
mix release --env=dev

#echo "Stopping old copy of app, if any..."
#_build/prod/rel/draw/bin/practice stop || true

echo "Starting app..."

_build/prod/rel/tasktracker/bin/tasktracker start

