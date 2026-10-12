#!/bin/bash
#
# Build script for OrangeFox Recovery - Samsung Galaxy S21 FE 5G (r9s)
#
# Usage:
#   ./build.sh              # build recovery image
#   ./build.sh -c           # clean build
#   ./build.sh -j 8         # limit jobs
#   ./build.sh -s [16G]     # create/enable swapfile (needs sudo) and build
#

set -e

DEVICE=r9s
PRODUCT=twrp_${DEVICE}
VARIANT=eng

MY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANDROID_ROOT="$(cd "${MY_DIR}/../../.." && pwd)"

# Android 14+ requires lunch combos in <product>-<release>-<variant> form.
# Detect the release name from build/release/release_config_map.mk if present,
# otherwise fall back to the legacy <product>-<variant> form.
RELEASE=""
if [ -f "${ANDROID_ROOT}/build/release/release_config_map.mk" ]; then
    RELEASE="$(grep -o 'declare-release-config[[:space:]]*,[[:space:]]*[a-zA-Z0-9_]*' \
        "${ANDROID_ROOT}/build/release/release_config_map.mk" \
        | grep -o '[a-zA-Z0-9_]*$' | head -n1)"
fi
if [ -n "${RELEASE}" ]; then
    LUNCH=${PRODUCT}-${RELEASE}-${VARIANT}
else
    LUNCH=${PRODUCT}-${VARIANT}
fi

CLEAN=0
JOBS=""
SWAP=0
SWAP_SIZE="16G"
SWAP_FILE="/home/swapfile"

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        -c | --clean )
                CLEAN=1
                ;;
        -j )
                JOBS="-j${2}"; shift
                ;;
        -j* )
                JOBS="-j${1#-j}"
                ;;
        -s | --swap )
                SWAP=1
                if [ "${2#-}" != "${2}" ] || [ -z "${2}" ]; then
                    : # no explicit size given
                else
                    SWAP_SIZE="${2}"; shift
                fi
                ;;
        -h | --help )
                echo "Usage: $0 [-c] [-j <jobs>] [-s [<size>]]"
                echo "  -c           clean build"
                echo "  -j <jobs>    limit parallel jobs"
                echo "  -s [<size>]  create/enable a swapfile (default 16G, needs sudo)"
                exit 0
                ;;
        * )
                echo "Unknown option: ${1}"
                exit 1
                ;;
    esac
    shift
done

# If -j was not given, pick a job count that fits in available RAM+swap to
# avoid OOM crashes (rough budget of 3GB of memory per parallel job).
if [ -z "${JOBS}" ]; then
    mem_kb=$(awk '/MemAvailable/ {print $2}' /proc/meminfo)
    swap_kb=$(awk '/SwapTotal/ {print $2}' /proc/meminfo)
    total_kb=$(( mem_kb + swap_kb ))
    budgeted=$(( total_kb / 1024 / 1024 / 3 ))
    cpus=$(nproc)
    if [ "${budgeted}" -lt 1 ]; then
        budgeted=1
    fi
    if [ "${budgeted}" -gt "${cpus}" ]; then
        budgeted="${cpus}"
    fi
    JOBS="-j${budgeted}"
    echo "==> Auto-tuned jobs: ${JOBS} (RAM+swap: $(( total_kb / 1024 / 1024 ))G)"
fi

add_swap() {
    if ! command -v btrfs >/dev/null 2>&1; then
        echo "ERROR: 'btrfs' not found, cannot create swapfile."
        exit 1
    fi
    if ! grep -qs "${SWAP_FILE}" /etc/fstab; then
        echo "/home/swapfile none swap defaults 0 0" | sudo tee -a /etc/fstab >/dev/null
    fi
    if [ ! -f "${SWAP_FILE}" ]; then
        echo "==> Creating swapfile ${SWAP_FILE} (${SWAP_SIZE})"
        sudo btrfs filesystem mkswapfile -s "${SWAP_SIZE}" "${SWAP_FILE}"
    fi
    if ! sudo grep -qs "${SWAP_FILE}" /proc/swaps; then
        echo "==> Enabling swap"
        sudo swapon "${SWAP_FILE}"
    fi
}

if [ "${SWAP}" -eq 1 ]; then
    add_swap
fi

if [ ! -f "${ANDROID_ROOT}/build/envsetup.sh" ]; then
    echo "ERROR: Android source tree not found at ${ANDROID_ROOT}"
    echo "Place this device tree at device/samsung/${DEVICE} inside the source tree."
    exit 1
fi

export ALLOW_MISSING_DEPENDENCIES=true
export FOX_BUILD_DEVICE=${DEVICE}
export LC_ALL="C"
# Match the device maintainer's tested recipe (skips OrangeFox patches).
export FOX_VANILLA_BUILD=1

cd "${ANDROID_ROOT}"

if [ "${CLEAN}" -eq 1 ]; then
    echo "==> Cleaning build output"
    rm -rf "out/target/product/${DEVICE}"
fi

echo "==> Sourcing build environment"
source build/envsetup.sh

echo "==> Lunching ${LUNCH}"
lunch "${LUNCH}"

echo "==> Building recovery image (full log: out/build_${DEVICE}.log)"
LOG="${ANDROID_ROOT}/out/build_${DEVICE}.log"
mkdir -p "$(dirname "${LOG}")"
if ! mka ${JOBS} adbd recoveryimage > "${LOG}" 2>&1; then
    echo "==> BUILD FAILED. Last 50 lines of the log:"
    tail -n 50 "${LOG}"
    exit 1
fi

WARN=$(grep -c ': warning' "${LOG}" || true)
ERR=$(grep -Ec '\berror:' "${LOG}" || true)
echo "==> Build finished: ${ERR} errors, ${WARN} warnings"

OUT="out/target/product/${DEVICE}"
echo ""
echo "==> Build finished"
ls -lh "${OUT}"/recovery.img 2>/dev/null || true
