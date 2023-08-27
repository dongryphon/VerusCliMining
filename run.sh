WRKR="$1"

# run.sh <workerName> once to save name to worker.txt
# run.sh alone to run using saved worker name

if [[ ! -z "${WRKR}" ]]; then
    echo "Setting worker name '${WRKR}'"
    echo "${WRKR}" > worker.txt
elif [[ -f worker.txt ]]; then
    WRKR="$(cat worker.txt)"
fi

echo "--------------------------------------------------"
echo "Worker: ${WRKR}"

# On first run, copy config.json to config.tpl as our template
if [[ ! -f config.tpl ]]; then
    echo "Backup config.json"
    cp config.json config.tpl
fi

# Generate clean config.json by replacing WORKER_NAME with real name
rm config.json

while IFS= read -r line; do
    # echo "DBG: ${line}"
    if [[ "${line}" =~ ^(.*)WORKER_NAME(.*)$ ]]; then
        echo "${BASH_REMATCH[1]}${WRKR}${BASH_REMATCH[2]}" >> config.json
    else
        echo "${line}" >> config.json
    fi
done < config.tpl

echo "Starting ccminer"
echo "--------------------------------------------------"

./ccminer/start.sh
