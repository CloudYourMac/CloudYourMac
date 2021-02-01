# Hyperconverged oVirt

oVirt Hyper converged setup is documented at

https://www.ovirt.org/documentation/gluster-hyperconverged/Gluster_Hyperconverged_Guide.html

The guide expects a host with multiple disks but in our case Mac devices are mostly single disk devices. In our kickstart file we manually partitioned disk to leave space for storage. 

To make it work for us

1. Follow the guide for steps 1-4 of Gluster setup
2. On Brick setup tab, instead of `sdb` for device name use `sda4`, RAID Type : `JBOD`.
3. Select Next to the review screen. On review screen, edit configuration. Scroll to `vars` section and add
```
gluster_infra_lvm: diskPartition
```
4. You must click `Save` on top before clicking `Deploy`
