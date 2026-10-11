# OFOX Device Tree for Samsung Galaxy S21 FE Exynos (5G) 
# SM-G990E/DS

## Release and install instructions
https://xdaforums.com/t/recovery-unofficial-ofox-sm-g990e-ds-samsung-s21-fe-5g-exynos-ofox-recovery-project-r11-3.4765885

## Clone repo
```bash 
git clone -b https://github.com/bekirakil-0/android_device_samsung_r9s.git
```

## Build 
```bash
export ALLOW_MISSING_DEPENDENCIES=true
export FOX_BUILD_DEVICE=r9s
export LC_ALL="C"
export FOX_VANILLA_BUILD=1
source build/envsetup.sh
lunch twrp_r9s-eng && mka adbd recoveryimage
```
