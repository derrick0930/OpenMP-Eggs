#!/bin/bash
cd /home/container || exit 1

XDG_RUNTIME_DIR=/tmp/runtime-container
mkdir -p "$XDG_RUNTIME_DIR" 2>/dev/null || { XDG_RUNTIME_DIR=/home/container/.xdg; mkdir -p "$XDG_RUNTIME_DIR"; }
chmod 700 "$XDG_RUNTIME_DIR"
export XDG_RUNTIME_DIR

export WINEARCH="${WINEARCH:-win32}"
REG="$WINEPREFIX/system.reg"

[ -f "$REG" ] && grep -q '^#arch=win64' "$REG" && export WINEARCH=win64

mkprefix() {
    wineboot --init
    wineserver -w
}

if [ ! -f "$REG" ]; then
    echo "[wine] membuat prefix ($WINEARCH), tunggu sebentar..."
    mkprefix
    if [ ! -f "$REG" ] && [ "$WINEARCH" = "win32" ]; then
        echo "[wine] prefix win32 gagal, mencoba win64..."
        rm -rf "$WINEPREFIX"
        export WINEARCH=win64
        mkprefix
    fi
fi

echo "[wine] $(wine --version) ($WINEARCH)"

PARSED=$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g')
echo ":/home/container$ ${PARSED}"
eval "exec ${PARSED}"