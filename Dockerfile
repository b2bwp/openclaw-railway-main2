FROM ghcr.io/openclaw/openclaw:latest

USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential python3 \
    && rm -rf /var/lib/apt/lists/*
USER openclaw

WORKDIR /app

COPY package.json pnpm-lock.yaml ./
RUN CI=true pnpm install --no-frozen-lockfile --config.confirmModulesPurge=false

COPY src/ src/
COPY entrypoint.sh ./
RUN chmod +x entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["./entrypoint.sh"]

