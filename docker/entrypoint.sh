#!/bin/bash
cd /home/container || exit 1

export WINEARCH="${WINEARCH:-win32}"

if [ ! -f "$WINEPREFIX/system.reg" ]; then
    echo "[wine] membuat prefix ($WINEARCH), tunggu sebentar..."
    wineboot --init >/dev/null 2>&1
    wineserver -w
fi

PARSED=$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g')
echo ":/home/container$ ${PARSED}"
eval "exec ${PARSED}"
