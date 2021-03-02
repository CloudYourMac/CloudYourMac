#!/bin/bash

INSTALLER=$1

echo Create Blank Image
mkdir -p output
hdiutil create -o output/MacOSInstaller -size 17000m -volname MacOSInstaller -layout GPTSPUD -fs HFS+J

echo Attach Blank Image
DISKNUM=$(hdiutil attach output/MacOSInstaller.dmg -noverify -mountpoint /Volumes/MacOSInstaller | grep GUID_partition_scheme | cut -d ' ' -f 1)
# EFI_PARTITION="${DISKNUM}s1"

# echo Mount and Copy OpenCore EFI
# mkdir -p output/imageEFI
# mount -t msdos $EFI_PARTITION output/imageEFI
# cp -a OpenCore/EFI output/imageEFI/

# echo Unmount EFI
# diskutil unmount output/imageEFI
# rm -rf output/imageEFI

echo Create Installer
echo "Running createinstallmedia tool. It needs sudo password"
sudo "$INSTALLER/Contents/Resources/createinstallmedia" --volume /Volumes/MacOSInstaller --nointeraction

echo Unmount Image
sudo hdiutil detach -force $DISKNUM
echo Let everthing cleaned up
sleep 5

echo Convert Image
qemu-img convert -f raw -O qcow2 output/MacOSInstaller.dmg output/MacOSInstaller.qcow2
rm -f output/MacOSInstaller.dmg