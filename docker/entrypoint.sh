#!/bin/bash
cd /home/container || exit 1

XDG_RUNTIME_DIR=/tmp/runtime-container
mkdir -p "$XDG_RUNTIME_DIR" 2>/dev/null || { XDG_RUNTIME_DIR=/home/container/.xdg; mkdir -p "$XDG_RUNTIME_DIR"; }
chmod 700 "$XDG_RUNTIME_DIR"
export XDG_RUNTIME_DIR

export WINEARCH="${WINEARCH:-win32}"
REG="$WINEPREFIX/system.reg"

if [ -f "$REG" ]; then
    have=win32
    grep -q '^#arch=win64' "$REG" && have=win64
    if [ "$have" != "$WINEARCH" ]; then
        echo "[wine] prefix $have tidak cocok dengan $WINEARCH, dibuat ulang"
        rm -rf "$WINEPREFIX"
    fi
fi

if [ ! -f "$REG" ]; then
    echo "[wine] membuat prefix ($WINEARCH), tunggu sebentar..."
    wineboot --init
    wineserver -w
fi

SERVER_DIR="${SERVER_DIR:-/home/container/server}"
mkdir -p "$SERVER_DIR"

if [ ! -f "$SERVER_DIR/omp-server.exe" ] && [ -f omp-server.exe ]; then
    echo "[setup] memindahkan file server ke $SERVER_DIR"
    for f in omp-server.exe omp-server.pdb components config.json bans.json gamemodes filterscripts plugins models npcmodes scriptfiles qawno Screenshots log.txt; do
        [ -e "$f" ] && mv "$f" "$SERVER_DIR/"
    done
fi

ln -sfn "$SERVER_DIR" "$WINEPREFIX/dosdevices/e:"
cd "$SERVER_DIR" || exit 1

echo "[wine] $(wine --version) ($WINEARCH)"

PARSED=$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g')
echo ":$PWD$ ${PARSED}"
eval "exec ${PARSED}"