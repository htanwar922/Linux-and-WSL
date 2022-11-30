# Recover lost files from corrupted windows and ext4.vhdx

## Mount ext4.vhdx in new WSL

> Search for the file in location like `C:\Users\<username>\AppData\Local\Packages\<CanonicalGroupLimited.Ubuntu-16.04onWindows_79rhkp1fndgsc>\LocalState` .<br>
>
 If you are trying to recover after a windows reset, search the above path in `C:\Windows.old` folder instead of `C:` directory :<br>`C:\Windows.old\Users\<username>\AppData\Local\Packages\<CanonicalGroupLimited.Ubuntu-16.04onWindows_79rhkp1fndgsc>\LocalState` .

> First double click the `ext4.vhdx` file. See that the disk shows up as online and initialized in `Disk Management`. If not, initialize the disk (right-click and see).

Note the Disk number \<n\> in above step and the follow the following instructions from ref [1]:

> Install a new WSL. In this WSL, run `lsblk`.

Alternatively, `fdisk -l` can be used.

> In an elevated Powershell, run `wsl --mount \\.\PhysicalDrive<n> --bare`.

> Switch back to WSL now. Run `lsblk` again and note the newly added `/dev/sdx` (may not be x).


## Repair disk and recover data

Following instructions as _root user_ from ref [2]:

> `mkdir /wsl-rec`<br>
  `mount /dev/sdx /wsl-rec`

If above doesn't work, try the below instructions and return back to mounting.

> `fsck.ext4 -v /dev/sdx`

If above command tells you to _update e2fsck_, do the same (see below) and return back above.

> `mke2fs -n /dev/sdx`

Try mounting again. If it fails, note the block numbers returned by above command and try this with all of those individually:

> `e2fsck -b <block-number> /dev/sdx`

## Update e2fsck

Run as _root user_ the following instructions from [3]:

> `wget https://sourceforge.net/projects/e2fsprogs/files/e2fsprogs/v1.46.5/e2fsprogs-1.46.5.tar.gz`<br>
  `tar xzf e2fsprogs*`<br>
  `cd e2fsprogs-1.46.5/`<br>
  `./configure && make && make install`


## References:

1. [Adding Another Disk to WSL2](https://joeferguson.me/adding-another-disk-to-wsl2/)
2. [Finding or Recovering your WSL Data](https://christopherkibble.com/posts/wsl-vhdx-recovery/)
3. [Update e2fsck](https://askubuntu.com/questions/747656/after-a-power-failure-unable-to-mount-the-drive-get-a-newer-version-of-e2fsck)