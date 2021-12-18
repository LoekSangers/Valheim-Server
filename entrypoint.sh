#!/bin/sh
export LD_LIBRARY_PATH=/root/valheim/linux64/:/root/.steam/steamcmd/linux64/:$LD_LIBRARY_PATH
export SteamAppID=892970

./valheim_server.x86_64 -name $SERVERNAME -port 2457 -nographics -batchmode -world $WORLDNAME -password $PASSWORD -public 0  