#!/bin/bash
set -e

chown -R openclaw:openclaw /data
chmod 700 /data

if [ ! -d /data/.linuxbrew ]; then
  cp -a /home/linuxbrew/.linuxbrew /data/.linuxbrew
fi

rm -rf /home/linuxbrew/.linuxbrew
ln -sfn /data/.linuxbrew /home/linuxbrew/.linuxbrew

# Clear stale jiti TypeScript cache to ensure plugin code changes take effect
rm -rf /tmp/jiti

# Ensure the active core msteams plugin path can resolve its runtime dependency.
# The npm-installed plugin under /data carries @microsoft/agents-hosting; the core path may not.
mkdir -p /usr/local/lib/node_modules/openclaw/extensions/msteams/node_modules/@microsoft || true
ln -sfn /data/.openclaw/extensions/msteams/node_modules/@microsoft/agents-hosting \
  /usr/local/lib/node_modules/openclaw/extensions/msteams/node_modules/@microsoft/agents-hosting || true

# nginx: public port 8080 → gateway:18789 + msteams:3978 + wrapper:3000
nginx -c /app/nginx.conf

# Node wrapper on internal port (setup wizard, gateway lifecycle, TUI)
export WRAPPER_PORT=3000
exec gosu openclaw node src/server.js
