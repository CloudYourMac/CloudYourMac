# oVirt Node NG

oVirt Node NG is a minimal CentOS based distribution with KVM hypervisor which will be managed with oVirt and provide computer and storage services for our cluster.

Anaconda installer has some hiccups when it sees Apple hardware and needs some workarounds.

&nbsp;

### 1. MacEFI

When Anaconda detects a MacOS system, it prefers creating a HFS+ based EFI partition but the macefi package is missing in the installer. This ends up throwing an error up 

**Resource to create this format macefi is unavailable**

Report : https://bugzilla.redhat.com/show_bug.cgi?id=1751311

The workarounds mentioned in the bugzilla aren't the best ones. We just need stop anaconda from detecting it as a Apple Hardware. It uses DMI Chassis information to check if it an Apple device. 
https://github.com/storaged-project/blivet/blob/3.4-devel/blivet/arch.py#L201

So a simple fix is to disable DMI driver in kernel and in that case things will work as expected. 

DMI driver can be easily disabled in kernel command line by adding `initcall_blacklist=dmi_id_init`. This blocks `dmi_id` driver to load.

&nbsp;

### 2. Bootloader Shim

Apple Firmware EFI isn't very happy with CentOS EFI bootloader shim and just hangs on black screen, due to unknown reasons as of now.

We just ignore this bootloader shim by removing all EFI boot entries and add a new one to boot grubx64.efi directly.

For installer iso, it is done with `ovirtiso2usb.sh` and installed system is done by kickstart script.

&nbsp;

## Installation

Considering you are planning to setup a cluster, the easiest installation method is to create a Anaconda Kickstart file and use it for automated installation.

A sample installation file (macpro.ks) configured to with custom partitioning and apply fixes is provided. It is based on a 1TB drive and reserves space for storage in hyperconverged setup and also has some network settings preconfigured.

For more information : https://www.ovirt.org/documentation/installing_ovirt_as_a_self-hosted_engine_using_the_cockpit_web_interface/

Storage : https://www.ovirt.org/documentation/installing_ovirt_as_a_self-hosted_engine_using_the_cockpit_web_interface/#Storage_Requirements_SHE_cockpit_deploy

Follow the steps below to install. The scripts are expected to run on MacOS.

&nbsp;

### Create Insaller USB

1. Download oVirt Node NG installer from https://www.ovirt.org/download/node.html 
2. Edit `macpro.ks` as per your requirement. 
3. Install 7zip 
```
brew install p7zip
```
3. Connect a USB stick to machine (Min 4G).
4. Run `ovirtiso2usb.sh` script.
```
ovirtiso2usb.sh <Path to oVirt Iso>
```
5. Select USB drive you want to use for installer.
6. Wait for script to finish and eject the disk.


### Installation

1. Connect USB to Apple machine.
2. Press and hold alt key and power on the machine.
3. Select USB to boot and press Enter
4. Grab a quick coffee
5. Come back to an oVirt Node NG installed host.


## Future

- Install over network