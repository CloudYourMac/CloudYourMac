# MacOS VM

Even though MacOS works on x86_64 architecture there are certain parts of hardware that it expects before it could boot. MacOS being targetted only for Apple machines, it is quite strict in terms of hardware requirements.

In high level these requirements are (AFAIK)

1. UEFI Services (ConsoleGOP and maybe more)
2. SMC Controller
3. APFS Driver
4. Correctly placed ACPI Devices
5. Maybe more

Virtualization products like VMware Fusion, VMware ESXi, VirtualBox and Parallels emulate required Apple hardware and implement requirements in VM UEFI firmware.
In our case, we have KVM which emulates a standard PC hardware so we use OpenCore bootloader to bridge the gap.

More details about OpenCore internals can be found at https://dortania.github.io/OpenCore-Install-Guide/

OpenCore helps us 
1. Boot MacOS VM
2. Passthrough internal GPU to VM. This is explained in later sections.

Just to be clear, even though OpenCore is targetted to run MacOS on non-Apple hardware which may / maynot be illegal but in our case we are running MacOS on Apple Hardware so its still a legal option.

Once oVirt is ready with its storage, its time for us to install our MacOS VM. We need a special MacOS Installer image, the one with OpenCore baked in to be able to boot in VM.

To create this installer image run

```
./createInstallerImage.sh
```
