#!/bin/bash

if [ -n "$UNION" ]; then
  unionfs-fuse -o cow /gmod-volume=RW:/gmod-base=RO /gmod-union
  while true; do
    /gmod-union/srcds_run -console -norestart -port ${PORT} -maxplayers ${MAXPLAYERS} -game garrysmod +app_update 4020 +gamemode ${GAMEMODE} +map ${MAP} +host_workshop_collection ${WORKSHOP} "${ARGS}"
  done
else
  while true; do
    /gmod-base/srcds_run -console -norestart -port ${PORT} -maxplayers ${MAXPLAYERS} -game garrysmod +app_update 4020 +gamemode ${GAMEMODE} +map ${MAP} +host_workshop_collection ${WORKSHOP} "${ARGS}"
  done
fi

