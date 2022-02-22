#!/bin/bash

if [ ${FLARE_NETWORK_ID} == "coston" ]
then
        echo "Coston"
        BOOTSTRAP_IPS=$(curl -m 10 -sX POST --data '{ "jsonrpc":"2.0", "id":1, "method":"info.getNodeIP" }' -H 'content-type:application/json;' https://coston.flare.network/ext/info | jq -r ".result.ip")
        BOOTSTRAP_IDS=$(curl -m 10 -sX POST --data '{ "jsonrpc":"2.0", "id":1, "method":"info.getNodeID" }' -H 'content-type:application/json;' https://coston.flare.network/ext/info | jq -r ".result.nodeID")
fi

if [ ${FLARE_NETWORK_ID} == "songbird" ]
then
        echo "Songbird"
        BOOTSTRAP_IPS=$(curl -m 10 -sX POST --data '{ "jsonrpc":"2.0", "id":1, "method":"info.getNodeIP" }' -H 'content-type:application/json;' https://songbird.flare.network/ext/info | jq -r ".result.ip")
        BOOTSTRAP_IDS=$(curl -m 10 -sX POST --data '{ "jsonrpc":"2.0", "id":1, "method":"info.getNodeID" }' -H 'content-type:application/json;' https://songbird.flare.network/ext/info | jq -r ".result.nodeID")
fi

printf "\n\x1b[32m## Flare Network (${FLARE_NETWORK_ID}) Deployment ##\x1b[0m\n\n"
printf "\x1b[33mNetwork: ${FLARE_NETWORK_ID}\x1b[0m\n"
# printf "\x1b[33mHTTP Host: ${HTTP_HOST}\x1b[0m\n"
printf "\x1b[33mPublic IP: ${LISTEN_ADDRESS}\x1b[0m\n"
printf "\x1b[33mDatabase Dir: ${DB_DIR}\x1b[0m\n"
printf "\x1b[33mLogs Dir: ${LOG_DIR}\x1b[0m\n"
printf "\x1b[33mLog Level: ${LOG_LEVEL}\x1b[0m\n"
printf "\x1b[33mBootstrap IPs: ${BOOTSTRAP_IPS}\x1b[0m\n"
printf "\x1b[33mBootstrap IDs: ${BOOTSTRAP_IDS}\x1b[0m\n"

/app/flare --network-id=${FLARE_NETWORK_ID} \
    --db-dir=${DB_DIR} \
    --log-dir=${LOG_DIR} \
    --chain-config-dir=${CHAIN_CONFIG_DIR} \
    --bootstrap-ips=${BOOTSTRAP_IPS} \
    --bootstrap-ids=${BOOTSTRAP_IDS} \
    --public-ip=${LISTEN_ADDRESS} \
    --log-level=${LOG_LEVEL}
    # --http-host=${HTTP_HOST:-127.0.0.1}