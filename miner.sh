#!/bin/bash
DIR="$(dirname ""$(realpath ""$0""))"""

CONFIG_FILE="${DIR}/ccminer/config.json"
CONFIG_TPL="${DIR}/config.json"
WORKER_FILE="${DIR}/worker.txt"
WORKER=

if [[ ! -f "${WORKER_FILE}" ]]; then
    read -p "Worker name: " WORKER
    echo "${WORKER}" > "${WORKER_FILE}"
else
    WORKER="$(cat ""${WORKER_FILE}"")"
fi

echo "--------------------------------------------------"
echo "Worker: ${WORKER}"

# Generate clean config.json by replacing WORKER_NAME with real name
echo "Generate config file: ${CONFIG_FILE}"
cat "${CONFIG_TPL}" | sed "s/WORKER_NAME/${WORKER}/g" > "${CONFIG_FILE}"

echo "Starting ccminer..."
echo "--------------------------------------------------"

~/ccminer/ccminer -c "${CONFIG_FILE}"
