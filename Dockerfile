FROM ghcr.io/openclaw/openclaw:latest

# nginx for multi-port reverse proxy (no body-parsing issues)
RUN apt-get update && apt-get install -y --no-install-recommends nginx \
    && rm -rf /var/lib/apt/lists/*

# Install msteams plugin dependencies into the stock extension
RUN cd /usr/local/lib/node_modules/openclaw/extensions/msteams && npm install --omit=dev

WORKDIR /app

COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

COPY src/ src/
COPY nginx.conf entrypoint.sh ./
RUN chmod +x entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["./entrypoint.sh"]
