#!/bin/bash
cd /home/container || exit 1

export WINEARCH="${WINEARCH:-win32}"

mkprefix() {
    wineboot --init >/dev/null 2>&1
    wineserver -w
}

if [ ! -f "$WINEPREFIX/system.reg" ]; then
    echo "[wine] membuat prefix ($WINEARCH), tunggu sebentar..."
    mkprefix
    if [ ! -f "$WINEPREFIX/system.reg" ] && [ "$WINEARCH" = "win32" ]; then
        echo "[wine] prefix win32 gagal, mencoba win64..."
        rm -rf "$WINEPREFIX"
        export WINEARCH=win64
        mkprefix
    fi
fi

echo "[wine] $(wine --version)"

PARSED=$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g')
echo ":/home/container$ ${PARSED}"
eval "exec ${PARSED}"