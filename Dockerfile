FROM node:16.5.0 as builder

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

FROM node:16.5.0-slim

WORKDIR app
COPY --from=builder temp/public public
RUN npm i sirv-cli

ENTRYPOINT npx sirv public --quiet --brotli --gzip --host 0.0.0.0 --maxage 604800
EXPOSE 8080