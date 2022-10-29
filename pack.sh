#!/bin/bash

TARGET=soft-serve

rm -rf ${TARGET}
mkdir ${TARGET}

cd ${TARGET}/
go build ../cmd/soft

cp ../Dockerfile .
cp ../docker-compose.yml .

ENV=".env"

echo "SOFT_SERVE_PORT=22" >> ${ENV}
echo "SOFT_SERVE_HOST=localhost" >> ${ENV}
echo "SOFT_SERVE_BIND_ADDRESS=0.0.0.0" >> ${ENV}
echo "SOFT_SERVE_KEY_PATH=ssh/soft_serve_server_ed25519" >> ${ENV}
echo "SOFT_SERVE_REPO_PATH=.repos" >> ${ENV}
echo "SOFT_SERVE_INITIAL_ADMIN_KEY=" >> ${ENV}
echo >> ${ENV}
echo "WORKDIR=/data" >> ${ENV}
echo >> ${ENV}
echo "HOST_BIND_ADDRESS=127.0.0.1" >> ${ENV}
echo "HOST_PORT=8022" >> ${ENV}
echo "HOST_REPOS_DIR=." >> ${ENV}
echo "HOST_SOFT_DIR=." >> ${ENV}

# echo '#!/bin/sh' >> soft-shell
# echo 'if [ -n "$*" ]; then shift; fi' >> soft-shell
# echo 'ssh -p 8022 -o StrictHostKeyChecking=no 127.0.0.1 $@' >> soft-shell

cd ..

tar zcf ${TARGET}.tgz ${TARGET}
rm -rf ${TARGET}
