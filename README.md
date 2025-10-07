

This repository contains the latest release of mesa for Debian stable with the amd64(x86-64) architecture.

## Download and installation

Builds can be downloaded from [**the releases page**](https://github.com/execlibs/mesa-debian/releases). After downloading, run **apt install mesa-X.X.X.deb**

---

## Requirements

The dependencies are no different from those in Debian. You can use the package not only in the stable release but also in its derivatives, such as LMDE, MX linux, antiX. In theory, you can install it in Ubuntu and it will work, but I haven't tested how stable it is.

---

## Build options

**amd-use-llvm** - option disabled, to force use ACO on amd gpus. In my experience, this reduces stutters and cache size in games using the OpenGL API.

**video-codecs** - options enabled for support more codecs

**unversion-libgallium** - option is enabled to avoid conflicts with the system libgallium

**Command line options:**

    meson setup --wipe build/ -D b_ndebug=true -D microsoft-clc=disabled -D gbm=enabled -D gles2=enabled -D egl=enabled -D android-libbacktrace=disabled -Dbuildtype=release -D b_lto=false -Dprefix=/usr

---

## Compilation

I use `buildroot_internal.sh` and `buildroot_internal.sh` to compile Mesa, you can use these scripts to compile your own Mesa builds. The first script creates Debian distro with debootstrap and the second script installs dev packages, compilie Mesa and generate .deb package.

## Revert to debian mesa

Reinstall these packages:

    apt reinstall -y libegl-mesa0, libgl1-mesa-dri, libglx-mesa0, mesa-va-drivers, mesa-libgallium, mesa-vulkan-drivers, libgbm1

Command revert standart Mesa packages

---

### Links to the sources

* https://mesa3d.org
* https://archive.mesa3d.org
* https://gitlab.freedesktop.org/mesa/mesa
