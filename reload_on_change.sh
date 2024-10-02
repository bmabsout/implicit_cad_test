#!/usr/bin/env bash

meshlab povclock.stl &
W_ID=$(xdotool search --sync --name "MeshLab 20")
echo $W_ID

inotifywait -e close_write,moved_to,create -m . |
while read -r directory events filename; do
  if [ "$filename" = "povclock.stl" ]; then
    echo "Supposed to reload"
    activewindow=$(xdotool getactivewindow)
    xdotool windowactivate --sync $W_ID key ctrl+shift+r
    xdotool windowactivate "$activewindow"
  elif [ "$filename" = "PovClock.hs" ]; then
    ghc -O2 PovClock.hs
    ./PovClock
  fi
done

