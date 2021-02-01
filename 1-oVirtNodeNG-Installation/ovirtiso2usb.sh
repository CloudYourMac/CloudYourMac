#!/bin/bash

diskutil list

echo "Enter the disk number for Ovirt USB. All data will be deleted"
read DISK_NUM

ISO=$1

diskutil unmountDisk /dev/rdisk$DISK_NUM
diskutil eraseDisk MS-DOS OVIRTUSB GPT /dev/rdisk$DISK_NUM

7z x -o/Volumes/OVIRTUSB $ISO

#Replace grub.cfg HD Label

LABEL=$(sed -n -e 's/^.*LABEL=//p' /Volumes/OVIRTUSB/EFI/BOOT/grub.cfg | tail -1 | cut -d ':' -f 1)
echo Replacing current LABEL $LABEL

sed -i ".bak" "s/$LABEL/OVIRTUSB/g" /Volumes/OVIRTUSB/EFI/BOOT/grub.cfg
sed -i "" "s/set timeout=60/set timeout=-1/g" /Volumes/OVIRTUSB/EFI/BOOT/grub.cfg
sed -i "" "/### BEGIN \/etc\/grub.d\/10_linux ###/r macpro-ks-grub.cfg" /Volumes/OVIRTUSB/EFI/BOOT/grub.cfg

echo Copying kickstart files
cp *.ks /Volumes/OVIRTUSB/

echo Replacing BOOTX64.EFI with grubx64.efi
mv /Volumes/OVIRTUSB/EFI/BOOT/BOOTX64.EFI /Volumes/OVIRTUSB/EFI/BOOT/BOOTX64.EFI-bak
mv /Volumes/OVIRTUSB/EFI/BOOT/grubx64.efi /Volumes/OVIRTUSB/EFI/BOOT/BOOTX64.EFI

diskutil unmountDisk /dev/rdisk$DISK_NUM
diskutil eject /dev/rdisk$DISK_NUM