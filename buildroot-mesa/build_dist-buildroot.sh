#!/bin/sh

# === Mesa3D Build Script ===
# Author: execlibs
# Purpose: Automated build of Mesa graphics library
# Features: 
#   - Downloads and compiles Mesa 25.2.4 from source
#   - Creates redistributable .deb package
#       - About 5.5 GB of free space is required
#      - And additional 1.5 GB is required for mesa compiliation
# Check root

# Check required files
for file in ./buildroot_internal.sh ./control ./debian-buildroot.sources; do
    if [ ! -f "$file" ]; then
        echo "File $file not found! try cd in script directory"
        exit 1
    fi
done

# Install debootstrap if not installed
if ! command -v debootstrap &> /dev/null; then
    apt update
    apt install -y debootstrap
fi         

rm -rf /srv/main00                   #if not cleaned

cp ./buildroot_internal.sh /tmp
cp ./debian-buildroot.sources /tmp                                     #copy important files to build
cp ./meson.options /tmp
cp ./control /tmp
cp ./postinst /tmp
cd /srv

mkdir main00

#create debian in chroot
debootstrap stable /srv/main00 http://deb.debian.org/debian

echo start image downloaded...

cd ./main00

cp /tmp/buildroot_internal.sh /srv/main00/                                                                   #copy important files to chroot
cp /tmp/debian-buildroot.sources /srv/main00/etc/apt/sources.list.d
cp /tmp/meson.options /srv/main00/
cp /tmp/postinst /srv/main00/
cp /tmp/control /srv/main00/

rm -f /srv/main00/etc/issue                                                        #cleaning
rm -f /srv/main00/etc/issue.net
rm -f /tmp/buildroot_internal.sh
rm -f /tmp/debian-buildroot.sources
rm -f /tmp/postinst
rm -f /tmp/control
                                                            #avoid mount bug(mount only dev)
mount --bind /dev dev/


chmod 0775 /srv/main00/buildroot_internal.sh                               #set exec attr

chroot /srv/main00 /bin/sh -c /buildroot_internal.sh                           #enter in build root and exec script in him

cd /srv/main00

umount /dev dev/                                #if chroot script exit, unmount all VFS
umount /proc proc/
umount /sys sys/

cp /srv/main00/exported.deb /srv
rm -rf /srv/main00                                       #cleaning

echo mesa is assembled. see /srv dir for find .deb package

#end message

