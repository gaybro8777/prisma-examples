#!/bin/sh

set -eu

npm install
npx prisma migrate dev --name init
npm run dev &
pid=$!

sleep 15

curl --fail 'http://localhost:3000/api' -H 'Accept-Encoding: gzip, deflate, br' -H 'Content-Type: application/json' -H 'Accept: application/json' -H 'Connection: keep-alive' -H 'DNT: 1' -H 'Origin: http://localhost:4000' --data-binary '{"query":"query {\n  feed {\n    id\n    content\n    author {\n      id\n      name\n      email\n    }\n  }\n}"}' --compressed

# check frontend
curl --fail 'http://localhost:3000/'

kill "$pid"
