#!/bin/bash
set -e

chown -R openclaw:openclaw /data
chmod 700 /data

if [ ! -d /data/.linuxbrew ]; then
  cp -a /home/linuxbrew/.linuxbrew /data/.linuxbrew
fi

rm -rf /home/linuxbrew/.linuxbrew
ln -sfn /data/.linuxbrew /home/linuxbrew/.linuxbrew

# nginx: public port 8080 → gateway:18789 + msteams:3978 + wrapper:3000
nginx -c /app/nginx.conf

# Node wrapper on internal port (setup wizard, gateway lifecycle, TUI)
export WRAPPER_PORT=3000
exec gosu openclaw node src/server.js
