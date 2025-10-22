#!/bin/sh

mount -t proc /proc proc/
mount -t sysfs /sys sys/

export DEBIAN_FRONTEND=noninteractive

apt update

apt install -y build-essential

apt build-dep -y mesa

apt build-dep -y wine

apt install -y wget curl

cd /

mkdir /build
mkdir /exported

wget https://archive.mesa3d.org/mesa-25.2.5.tar.xz
tar xf /mesa-25.2.5.tar.xz -C /build

cd /build

cp -r /build/mesa-25.2.5/* /build

rm -f /build/meson.options

cp /meson.options /build

meson setup --wipe build/ -D b_ndebug=true -D microsoft-clc=disabled -D gbm=enabled -D gles2=enabled -D egl=enabled -D android-libbacktrace=disabled -Dbuildtype=release -D b_lto=false -Dprefix=/usr

meson compile -C build/

meson install --strip --destdir /exported -C build

cd /exported                        #generate .deb package
mkdir DEBIAN
cp /postinst /exported/DEBIAN
cp /control /exported/DEBIAN
rm -rf ./usr/include
chmod 0775 ./
chown -hR root:root ./
dpkg-deb -b /exported
mv exported.deb mesa-updated.deb

apt clean
apt update

rm -f /buildroot_internal.sh


