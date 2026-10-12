# OrangeFox Device Tree for Samsung Galaxy S21 FE 5G Exynos (SM-G990E/DS) — r9s

## STATUS: NOT WORKING

> **The recovery built from this tree does not boot.**
>
> After flashing, the device reboots straight into **Download Mode (ODIN mode)**
> instead of starting OrangeFox. No error message is shown on screen — the
> bootloader simply rejects the image and falls back to download mode.

This is a **work-in-progress / non-functional** device tree. Do not expect a
bootable recovery from it as-is.

---

## Observed behaviour

- Image builds successfully and fits the recovery partition (see below).
- Flashing via Odin (AP slot, `*.img.tar`) or from an existing custom recovery
  (`.img`, `.zip`) installs without errors.
- Rebooting to recovery goes directly to **Download Mode** (silent rejection).

## Things that were tried

- **Size reduction** — the recovery partition is `64 MiB` (`67108864` bytes) and
  the default build produced an image of `~66 MiB`, which does not fit. Removed
  unused kernel modules (camera/ISP, NPU, DSP, video codec, audio, Wi-Fi/BT,
  sensors, NFC) from `recovery/root/lib/modules` and their entries in
  `modules.load.recovery`. The image now fits (~60.7 MiB) with ~3.3 MiB margin.
- **`FOX_VANILLA_BUILD=1`** — matches the original maintainer's documented
  recipe. Does not fix the no-boot issue.
- Removed the deprecated `TARGET_USES_64_BIT_BINDER := true` from `BoardConfig.mk`.

None of the above fixed the **Download Mode** problem.

## Known-good upstream reference

The original maintainer (bekirakil) has a working R11.3 build and install guide:

- XDA: https://xdaforums.com/t/recovery-unofficial-ofox-sm-g990e-ds-samsung-s21-fe-5g-exynos-ofox-recovery-project-r11-3.4765885
- Tree: https://github.com/bekirakil-0/android_device_samsung_r9s/tree/fox_14.1

Their install method requires a separate **`vbmeta_patch.tar`** flashed in the
Odin **AP** slot *before* the recovery `.img.tar`, for a fresh install — or
flashing the `.zip` from an existing custom recovery.

## Build

```bash
export ALLOW_MISSING_DEPENDENCIES=true
export FOX_BUILD_DEVICE=r9s
export LC_ALL="C"
export FOX_VANILLA_BUILD=1
source build/envsetup.sh
lunch twrp_r9s-ap2a-eng
mka adbd recoveryimage
```

Or simply:

```bash
./build.sh -j8
```

> Note: on an Android 14.1 manifest the lunch combo must be
> `twrp_r9s-ap2a-eng` (release `ap2a`), not the legacy `twrp_r9s-eng`.

## Partition sizes

| Partition | Size |
|-----------|------|
| `BOARD_RECOVERYIMAGE_PARTITION_SIZE` | `67108864` bytes (64 MiB) |
| Built image (trimmed) | `63590416` bytes (~60.7 MiB) |
| Margin | `~3.3 MiB` |

## Clone

```bash
git clone -b fox_14.1 https://github.com/spacexjr/ofox-r9s-device-tree.git
```

## TODO

- [ ] Find why the bootloader rejects the recovery image (AVB / vbmeta / image
      layout).
- [ ] Get a bootable image on device.
- [ ] Re-validate any module trimming once boot works.
