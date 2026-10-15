#!/usr/bin/env bash
#
# OrangeFox recovery build script for the Samsung Galaxy S21 FE 5G (r9s)
#
# Usage:
#   ./build.sh              # build recoveryimage (and OrangeFox zip installer)
#   ./build.sh clean        # remove the output directory first, then build
#   ./build.sh bacon        # build all recovery-related targets
#
# The number of parallel jobs can be overridden with JOBS, e.g.:
#   JOBS=16 ./build.sh
#
set -o pipefail

DEVICE="r9s"
LUNCH_TARGET="twrp_${DEVICE}-eng"
TARGET="${1:-recoveryimage}"
JOBS="${JOBS:-8}"

# locate the android source root (device/samsung/r9s -> ../../..)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOP="$(cd "${SCRIPT_DIR}/../../.." && pwd)"

if [ ! -f "${TOP}/build/envsetup.sh" ]; then
    echo "ERROR: could not find the Android source tree at '${TOP}'"
    exit 1
fi

cd "${TOP}"

echo "==> Android source tree : ${TOP}"
echo "==> Target              : ${TARGET}"
echo "==> Jobs                : -j${JOBS}"

export ALLOW_MISSING_DEPENDENCIES=true
export FOX_BUILD_DEVICE="${DEVICE}"

# Apply BMO theme assets
"${SCRIPT_DIR}/tools/bmotheme.sh"

# NOTE: build/envsetup.sh returns a non-zero status (its last internal command
# short-circuits), so don't run this under `set -e`.
# shellcheck disable=SC1091
. build/envsetup.sh

lunch "${LUNCH_TARGET}" || { echo "ERROR: lunch failed"; exit 1; }

if [ "${TARGET}" = "clean" ]; then
    echo "==> Cleaning ${DEVICE} output ..."
    rm -rf "${OUT}"
    TARGET="recoveryimage"
fi

echo "==> Building ${TARGET} ..."
mka "${TARGET}" -j"${JOBS}"
BUILD_RC=$?

echo
if [ "${BUILD_RC}" -eq 0 ]; then
    echo "==> Build finished. Outputs in ${OUT}:"
    ls -lh "${OUT}"/OrangeFox-* 2>/dev/null || true
else
    echo "==> Build FAILED (rc=${BUILD_RC})"
fi

exit "${BUILD_RC}"
