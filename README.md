# Simple-Kria-Kv260-Example

<!--- ######################################################## -->

# Before you clone the GIT repository

https://confluence.slac.stanford.edu/x/vJmDFg

<!--- ######################################################## -->

# Clone the GIT repository

```bash
$ git clone --recursive git@github.com:slaclab/Simple-Kria-Kv260-Example
```

<!--- ######################################################## -->

# How to generate the SOC .BIT and .XSA files

1) Setup Xilinx PATH and licensing (if on SLAC AFS network) else requires Vivado install and licensing on your local machine

```bash
$ source Simple-Kria-Kv260-Example/firmware/setup_env_slac.sh
```

2) Go to the target directory and make the firmware:

```bash
$ cd Simple-Kria-Kv260-Example/firmware/targets/SimpleKriaKv260Example/
$ make
```

3) Optional: Review the results in GUI mode

```bash
$ make gui
```

The .bit and .XSA files are dumped into the SimpleKriaKv260Example/image directory:

```bash
$ ls -lath SimpleKriaKv260Example/images/
total 47M
drwxr-xr-x 5 ruckman re 2.0K Feb  7 07:13 ..
drwxr-xr-x 2 ruckman re 2.0K Feb  4 21:15 .
-rw-r--r-- 1 ruckman re  14M Feb  4 21:15 SimpleKriaKv260Example-0x01000000-20220204204648-ruckman-90df89c.xsa
-rw-r--r-- 1 ruckman re  33M Feb  4 21:14 SimpleKriaKv260Example-0x01000000-20220204204648-ruckman-90df89c.bit
```

<!--- ######################################################## -->

# How to build Petalinux images

1) Generate the .bit and .xsa files (refer to `How to generate the SOC .BIT and .XSA files` instructions).

2) Setup Xilinx licensing and petalinux software (if on SLAC AFS network) else requires Xilinx & petalinux install on your local machine

```bash
$ source Simple-Kria-Kv260-Example/firmware/setup_env_slac.sh
$ source /path/to/petalinux/2022.2/settings.sh
```

3) Go to the target directory and run the `CreatePetalinuxProject.sh` script with arg pointing to path of .XSA file:

```bash
$ cd Simple-Kria-Kv260-Example/firmware/targets/SimpleKriaKv260Example/
$ source CreatePetalinuxProject.sh images/SimpleKriaKv260Example-0x01000000-20220204204648-ruckman-90df89c.xsa
```

<!--- ######################################################## -->

# How to make the SD memory card for the first time

1) Creating Two Partitions.  Refer to URL below

https://xilinx-wiki.atlassian.net/wiki/x/EYMfAQ

2) Copy For the boot images, simply copy the files to the FAT partition.
This typically will include system.bit, BOOT.BIN, image.ub, and boot.scr.  Here's an example:

```bash
sudo mount /dev/sde1 boot
sudo cp Simple-Kria-Kv260-Example/firmware/build/petalinux/SimpleKriaKv260Example/images/linux/system.bit boot/.
sudo cp Simple-Kria-Kv260-Example/firmware/build/petalinux/SimpleKriaKv260Example/images/linux/BOOT.BIN   boot/.
sudo cp Simple-Kria-Kv260-Example/firmwarebuild/petalinux/SimpleKriaKv260Example/images/linux/image.ub    boot/.
sudo cp Simple-Kria-Kv260-Example/firmware/build/petalinux/SimpleKriaKv260Example/images/linux/boot.scr   boot/.
sudo sync boot/
sudo umount boot
```

3) Power down the KV260 board

4) Confirm that MODE[3:0]_C2M = b"1110" for SD-memory boot mode (non-default loading)

```
MODE3_C2M = R162 = open (remove resistor)
MODE2_C2M = R163 = open (remove resistor)
MODE2_C1M = R164 = open (default)
MODE2_C0M = R165 = 499 Ohm (default)
```

<img src="docs/images/KV260_SD_BOOT.png" width="200">

5) Power up the KV260 board

6) Confirm that you can ping the boot after it boots up

<!--- ######################################################## -->

# How to remote update the firmware bitstream

- Assumes the DHCP assigned IP address is 10.0.0.10

1) Using "scp" to copy your .bit file to the SD memory card on the RFSoC.  Here's an example:

```bash
scp SimpleKriaKv260Example-0x01000000-20220204204648-ruckman-90df89c.bit root@10.0.0.10:/media/sd-mmcblk0p1/system.bit
```

2) Send a "sync" and "reboot" command to the RFSoC to load new firmware:  Here's an example:

```bash
ssh root@10.0.0.10 '/bin/sync; /sbin/reboot'
```

<!--- ######################################################## -->

# How to install the Rogue With Anaconda

> https://slaclab.github.io/rogue/installing/anaconda.html

<!--- ######################################################## -->

# How to run the Rogue GUI

- Assumes the DHCP assigned IP address is 10.0.0.10

1) Setup the rogue environment (if on SLAC AFS network) else install rogue (recommend Anaconda method) on your local machine

```bash
$ source Simple-Kria-Kv260-Example/software/setup_env_slac.sh
```

2) Go to software directory and lauch the GUI:

```bash
$ cd Simple-Kria-Kv260-Example/software
$ python scripts/devGui.py --ip 10.0.0.10
```

<!--- ######################################################## -->
