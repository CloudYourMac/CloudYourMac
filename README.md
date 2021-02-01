# Cloud Your Mac

Cloud Your Mac helps you run your Mac infrastructure like AWS. It aims to virtualize MacOS legally on Apple Hardware. 

Cloud Your Mac has following targets

- Run Mac VMs with near native speeds.
- Utilize maximum capability of your Apple Hardware.
- Easily convert your current BareMetal or slow MacOS virtualization to faster VMs
- Use already available internal GPUs to drive display and possibility of using external Monitor
- All for free.

We do this by using 

- [oVirt Virtualization](https://www.ovirt.org/)
- [OpenCore bootloader](https://dortania.github.io/OpenCore-Install-Guide/)

Cloud Your Mac provides solutions to set these up and work together.

&nbsp;

## Supported Devices

As of now, Cloud Your Mac is tested on the following hardware

- MacPro 2013
  

&nbsp;

## oVirt

oVirt is a KVM - libvirt based virtualization platform. It is the upstream project of Redhat Virtualization. oVirt provides a central management for virtual machines.
oVirt can be installed on CentOS, RHEL or oVirt Node NG - a mini CentOS based distribution.

oVirt supports Hyperconverged setup using Gluster providing storage and compute services.

&nbsp;

## OpenCore Bootloader

OpenCore bootloader is an opensource bootloader that allows booting MacOS on any x86 machine. We use OpenCore to boot our KVM based MacOS VM.

&nbsp;

## Installation

To Cloud Your Mac we need to do the following

1. Install oVirt Node NG on your hosts.
2. Setup oVirt Hyperconverged.
3. Install MacOS VM.
4. GPU passthrough to MacOS VM.
5. Extras

Details of each step is provided in respective folder.

