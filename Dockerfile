FROM node:16.18.0-slim as builder

WORKDIR temp
COPY public public
COPY src src
COPY package.json .
COPY package-lock.json .
COPY rollup.config.js .
COPY tsconfig.json .

RUN npm update -g npm
RUN npm install
RUN npm run build

FROM node:16.18.0-slim

WORKDIR app
COPY --from=builder temp/public public
RUN npm i sirv-cli

LABEL traefik.enable=true
LABEL traefik.http.routers.uksivt_shedule_front.entrypoints=websecure
LABEL traefik.http.routers.uksivt_shedule_front.rule=Host(`uksivt.com`)
LABEL traefik.http.routers.uksivt_shedule_front.tls=true
LABEL traefik.http.routers.uksivt_shedule_front.tls.certresolver=production

ENTRYPOINT npx sirv public --quiet --brotli --gzip --host 0.0.0.0 --maxage 604800
EXPOSE 8080
