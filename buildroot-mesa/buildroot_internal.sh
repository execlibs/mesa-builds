#!/bin/sh
                                                               #mount other VFS to avoids bugs here
mount -t proc /proc proc/
mount -t sysfs /sys sys/

export DEBIAN_FRONTEND=noninteractive                          #suppress all messages during build. If build fail exit in non chroot script and delete dist

apt update

apt install -y build-essential                                  #download gcc and other build tools

apt build-dep -y mesa

apt build-dep -y wine                                            #for build wine but not requried

apt install -y wget curl                                     #install download tools

cd /

mkdir /build                                     #src dir
mkdir /exported                                  #output dir

wget https://archive.mesa3d.org/mesa-25.2.4.tar.xz                             #downaload sources
tar xf /mesa-25.2.4.tar.xz -C /build                                   #unpack sources

cd /build

cp -r /build/mesa-25.2.4/* /build                                        #recursive copy in build dir

rm -f /build/meson.options                                          #remove config file and replace him

cp /meson.options /build
#mesa command line build options for release build
meson setup --wipe build/ -D b_ndebug=true -D microsoft-clc=disabled -D gbm=enabled -D gles2=enabled -D egl=enabled -D android-libbacktrace=disabled -Dbuildtype=release -D b_lto=false -Dprefix=/usr

meson compile -C build/                                               #BUILD!!!

meson install --strip --destdir /exported -C build                         #remove and minimazation file size for binaries

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

rm -f /buildroot_internal.sh                                #cleaning


