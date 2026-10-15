# OrangeFox Recovery R12.1 — Samsung Galaxy S21 FE Exynos

<p align="center">
  <img src="https://img.shields.io/badge/OrangeFox-R12.1-orange?style=for-the-badge" alt="OrangeFox R12.1">
  <img src="https://img.shields.io/badge/Device-Galaxy%20S21%20FE-blue?style=for-the-badge" alt="Samsung Galaxy S21 FE">
  <img src="https://img.shields.io/badge/SoC-Exynos%202100-lightgrey?style=for-the-badge" alt="Exynos 2100">
  <img src="https://img.shields.io/badge/Status-Experimental-red?style=for-the-badge" alt="Experimental">
</p>

<p align="center">
  An unofficial OrangeFox Recovery device tree for the Samsung Galaxy S21 FE Exynos (r9s).
</p>

---

## About

This repository contains device-specific configuration and build files for the unofficial port of **OrangeFox Recovery R12.1** to the Samsung Galaxy S21 FE Exynos variant.

The goal is to adapt the recovery environment to the device's hardware, partition layout, boot image format, and Samsung-specific boot requirements.

This project is intended for development, testing, and further investigation of OrangeFox Recovery compatibility with the Exynos-based Galaxy S21 FE.

## Device Information

| Property | Details |
|---|---|
| Device | Samsung Galaxy S21 FE |
| Codename | `r9s` |
| SoC | Samsung Exynos 2100 |
| Recovery | OrangeFox Recovery R12.1 |
| Project type | Unofficial port |
| Development status | Experimental |

## Project Goals

- Port OrangeFox Recovery R12.1 to the Galaxy S21 FE Exynos.
- Adapt device-specific recovery configuration.
- Configure recovery image generation and packaging.
- Address Samsung-specific boot image requirements.
- Investigate theme integration and recovery interface behavior.
- Test partition mounting, internal storage, and ADB functionality.
- Improve device compatibility and recovery stability.

## Repository

**GitHub:** [spacexjr/ofox-r9s-device-tree](https://github.com/spacexjr/ofox-r9s-device-tree)

## Build Environment

A Linux build environment with the dependencies required by the selected OrangeFox source tree is recommended.

Typical requirements include:

- Git
- Python 3
- Java and Android build dependencies
- An OrangeFox R12.1-compatible source tree
- Sufficient RAM and disk space
- Device-specific configuration files and required build tools

Refer to the documentation for the exact OrangeFox source revision being used.

## Getting Started

Clone this repository into the appropriate device directory inside your OrangeFox source tree:

```bash
git clone https://github.com/spacexjr/ofox-r9s-device-tree.git \
  -b fox_12.1 --depth=1 device/samsung/r9s
```

Make sure the `fox_12.1` branch exists and matches the source version you intend to build.

Initialize and synchronize the OrangeFox source according to the instructions for your selected R12.1 revision.

Then configure the build environment and select the recovery target supported by this device tree.

> The exact build commands depend on the source manifest, build scripts, and device configuration. Consult the files in this repository before starting a build.

## Compatibility

This project targets the **Samsung Galaxy S21 FE Exynos (`r9s`)**.

The Snapdragon Galaxy S21 FE (`r9q`) uses a different hardware platform and device-specific components. Its recovery images, kernel configuration, and vendor components must not be assumed to work on the Exynos variant.

Always verify the device model, image format, and partition requirements before flashing.

## Development Status

| Component | Status |
|---|---|
| Recovery compilation | Successfully built |
| Recovery boot | Reported working on a test build |
| Touchscreen | Requires further testing |
| Internal storage | Requires further testing |
| `/data` decryption | Requires further testing |
| ADB | Requires further testing |
| OrangeFox theme | Under investigation |
| Daily-use stability | Not established |

The status above reflects the currently reported test results. Individual features may behave differently between builds.

## Known Issues

### Blue Recovery Theme

The recovery currently boots successfully, but the interface appears **blue instead of the expected OrangeFox orange theme**.

The cause is currently unknown.

Additionally, the orange theme option does not appear in the recovery settings.

Possible areas for investigation include:

- OrangeFox theme resources not being included in the build.
- Theme configuration not being applied correctly.
- Missing OrangeFox-specific components.
- Differences between the recovery source revision and the device tree configuration.

These are possible causes, not confirmed diagnoses.

**Current status:** Under investigation.

Contributions and suggestions to identify the cause and restore the expected OrangeFox theme are welcome.

### Other Features Requiring Verification

The following functionality still needs testing before the recovery can be considered reliable for everyday use:

- Internal storage access.
- Data partition decryption.
- Partition mounting.
- ADB connectivity.
- Reboot behavior and recovery re-entry.

## Testing and Bug Reports

When reporting an issue, please include:

- Exact device model and variant.
- OrangeFox source revision and device tree branch.
- Commit hash used for the build.
- Build date and recovery image version.
- Recovery logs and relevant error messages.
- Steps to reproduce the problem.

For theme-related issues, screenshots of the recovery interface and the available theme settings are especially useful.

## Contributing

Contributions, testing reports, and technical suggestions are welcome.

If you find a solution to an existing issue, please provide the relevant changes and supporting test results so they can be reviewed and reproduced.

## Safety Notice

- This is an unofficial and experimental recovery port.
- Flashing an incompatible image can prevent the device from booting.
- Back up important data before testing.
- Keep a copy of the original firmware and understand the available recovery procedure.
- Do not format or wipe partitions unless you understand the consequences.
- Do not assume that successful booting means every recovery feature works correctly.

## Disclaimer

This project is provided **as is**, without warranties of any kind.

The maintainers are not responsible for data loss, device damage, boot failures, or other problems resulting from the use of this project.

**Use at your own risk.**

## Credits

- [OrangeFox Recovery](https://orangefox.download/)
- [Team Win Recovery Project (TWRP)](https://twrp.me/)
- Samsung Galaxy S21 FE Exynos community
- Contributors and testers involved in recovery development

---

<p align="center">
  Unofficial OrangeFox Recovery R12.1 port for the Samsung Galaxy S21 FE Exynos.
</p>
