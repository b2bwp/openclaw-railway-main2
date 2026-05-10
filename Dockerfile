FROM ghcr.io/openclaw/openclaw:latest

WORKDIR /app

COPY package.json pnpm-lock.yaml ./
RUN pnpm install --no-frozen-lockfile

COPY src/ src/
COPY entrypoint.sh ./
RUN chmod +x entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["./entrypoint.sh"]

