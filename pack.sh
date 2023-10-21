#!/bin/bash

if [[ "$#" = 0 ]]; then
    echo "Usage: pack.sh <Version> [CommitSHA]"
    exit
fi

version=$1
commit=$(git rev-parse --short HEAD 2> /dev/null)
if [ "$commit" = "" ] && [ "$2" = "" ]; then
    echo "Usage: pack.sh <Version> [CommitSHA]"
    exit
fi

TARGET=soft-serve

rm -rf ${TARGET}
mkdir ${TARGET}

cd ${TARGET}/
ldflags="-X 'main.Version=${version}' -X 'main.CommitSHA=${commit}'"
CGO_ENABLED=0 go build -ldflags="${ldflags} -w" ../cmd/soft

cp ../Dockerfile .
cp ../docker-compose.yml .

ENV=".env"

SOFT_SERVE_PORT=22
echo "SOFT_SERVE_PORT=${SOFT_SERVE_PORT}" >> ${ENV}
echo "SOFT_SERVE_SSH_PUBLIC_URL=ssh://localhost:${SOFT_SERVE_PORT}" >> ${ENV}
echo "SOFT_SERVE_SSH_LISTEN_ADDR=0.0.0.0" >> ${ENV}
echo "SOFT_SERVE_DATA_PATH=/data" >> ${ENV}
echo "SOFT_SERVE_SSH_KEY_PATH=ssh/soft_serve_server_ed25519" >> ${ENV}
echo "SOFT_SERVE_INITIAL_ADMIN_KEYS=" >> ${ENV}

echo >> ${ENV}
echo "WORKDIR=/data" >> ${ENV}
echo >> ${ENV}
echo "HOST_BIND_ADDRESS=127.0.0.1" >> ${ENV}
echo "HOST_PORT=8022" >> ${ENV}
echo "HOST_DATA_DIR=." >> ${ENV}
echo "HOST_SOFT_DIR=." >> ${ENV}

# echo '#!/bin/sh' >> soft-shell
# echo 'if [ -n "$*" ]; then shift; fi' >> soft-shell
# echo 'ssh -p 8022 -o StrictHostKeyChecking=no 127.0.0.1 $@' >> soft-shell

cd ..

tar zcf ${TARGET}.tgz ${TARGET}
rm -rf ${TARGET}
