#!/usr/bin/env bash
set -euo pipefail

DEVICE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
ROOT="${DEVICE_DIR}"

if [[ -n "${ORANGEFOX_TOP:-}" ]]; then
    FOX="$(cd -- "${ORANGEFOX_TOP}" && pwd -P)"
elif [[ -n "${R9S_TOP_DIR:-}" ]]; then
    FOX="$(cd -- "${R9S_TOP_DIR}" && pwd -P)"
elif [[ -f "${DEVICE_DIR}/../../../build/envsetup.sh" ]]; then
    FOX="$(cd -- "${DEVICE_DIR}/../../.." && pwd -P)"
elif [[ -f "${DEVICE_DIR}/../fox_12.1/build/envsetup.sh" ]]; then
    FOX="$(cd -- "${DEVICE_DIR}/../fox_12.1" && pwd -P)"
else
    echo "ERROR: OrangeFox 12.1 source tree not found." >&2
    exit 1
fi

mkdir -p \
"$FOX/bootable/recovery/gui/theme/portrait_hdpi/images/Default/About"

cp -f \
"$ROOT/assets/theme/maintainer.png" \
"$FOX/bootable/recovery/gui/theme/portrait_hdpi/images/Default/About/maintainer.png"

echo "BMO theme assets synced."