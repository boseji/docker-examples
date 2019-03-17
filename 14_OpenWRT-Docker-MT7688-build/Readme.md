# Building OpenWRT for MT7688 on Docker

In this part we are building a Linux Image for an Embedded device.<br>
The device we look at *[Seeed LinkIt Smart 7688][1]*.

![LinkIt Smart 7688 Features][2]

This device contains ***128MByte DDR1 RAM*** and ***32MByte SPI NOR FLASH***.

It runs on a **[MediaTek MT7688AN][4]** core.
It integrates a 1T1R 802.11n Wi-Fi radio, a 580MHz MIPS® 24KEc™ CPU, 
1-port fast Ethernet PHY, USB2.0 host, PCIe, SD-XC, I2S/PCM and 
multiple low-speed IOs in a single SoC.

Capable of running *[OpenWRT][3]* Linux distribution.

Latest supported version of **OpenWRT** on *MT7688* is ***[v18.06.2][5]*** as
as of *March, 2019*. You can also obtain a [pre-built image][6] of the build. 

Here is link to Official Documentation about the module:

https://docs.labs.mediatek.com/resource/linkit-smart-7688/en/get-started/get-started-with-the-linkit-smart-7688-development-board

We would be using a derived docker image that would support the build.

## Typical Procedure for the Build an OpenWRT Image

 1. Choose correct OS, typically some Debian or Ubuntu Image
 2. Install Build Dependencies
 3. Get Source Code
 4. Setup Feeds
 5. Install Feeds
 6. Do System and Subsystem Level Configuration
 7. Initiate Build process

## Procedure specific to MT7688 for OpenWRT v18.06.2

 1. Choose Ubuntu 14.04 due its support and legacy tooling
 2. Build Dependencies install:
    ```shell
    sudo apt-get install git g++ make libncurses5-dev subversion\
    libssl-dev gawk libxml-parser-perl unzip wget python xz-utils
    ```
 3. Get the Sources and select the correct branch:
    ```shell
    git clone https://github.com/openwrt/openwrt.git
    cd openwrt
    git checkout -b v18.06.2
    ```
 4. Setup Feeds (in `openwrt` directory):
    ```shell
    cp feeds.conf.default feeds.conf
    echo src-git linkit https://github.com/MediaTek-Labs/linkit-smart-7688-feed.git >> feeds.conf
    ```
    The last line adds the *MediaTek official feed*.
 5. Install the Feeds (in `openwrt` directory):
    ```shell
    ./scripts/feeds update
    ./scripts/feeds install -a
    ```
 6. Configure the build system (in `openwrt` directory):
    ```shell
    make menuconfig
    ```
    Make sure to select the following:
      - System Target as `MediaTek Ralink MIPS`
      - Sub Target as `MT76x8 based boards`
      - Target profile as `MediaTek LinkIt Smart 7688`
  
    This would configure the build for our 
    *[Seeed LinkIt Smart 7688 board][1]*

    Feel free to add any additional packages from the menu.

    After completion just press `Esc` + `Esc` (2 time `Esc` key)
    and default name to save to would be `.config`.
 7. Build Process (in `openwrt` directory):
    ```shell
    make prereq
    make V=99 -j$(nproc)
    ```
    This command would find out the number of processors and schedule
    the build to span over multiple cores.<br>
    In case there is some problem then run a different command:
    ```shell
    make V=s
    ```
    Removing the multiple core build helps to reduce the confusion in output.<br>
    One can also measure the execution time by using `time` command in shell:
    ```shell
    make prereq
    time make V=99 -j$(nproc)
    ```
 8. Final Build image - If every thing goes well then the final system image
    can be found at `bin/targets/ramips/mt76x8/` directory.<br>
    Eg: `bin/targets/ramips/mt76x8/openwrt-ramips-mt76x8-LinkIt7688-squashfs-sysupgrade.bin`<br>
    One rename this file to `lks7688.img` for USB based update.

## Docker Image

Here we are creating a derived docker image. For this image we would start
with *Ubuntu 14.04* as the base and install the required build dependencies.

**[Dockerfile][7]**

```Dockerfile
FROM ubuntu:14.04

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y nano autoconf automake libtool make patch texinfo gettext \
    pkg-config git g++ make libncurses5-dev subversion libssl-dev gawk \
    libxml-parser-perl unzip wget python xz-utils && \
    apt-get autoclean -y && \
    apt-get autoremove -y
```

We have additionally installed `nano` to help in some basic edit.

## Usage, Process & Scripts

 The build is designed to be a sequence of scripts initiated by tail-chaining.

```
1_start-shell.sh --> 3_Get_Sources.sh (docker) --> 4_build.sh (docker)
```

Here are the specifics of each script:

 * **[`1_start-shell.sh`][8]** = This builds the docker image if it does not exist.<br>
 And starts a Shell execution for the next script `3_Get_Sources.sh`.
 * **[`3_Get_Sources.sh`][9]** = This would run inside the container. It fetches the
 *OpenWRT* source repository and sets it up with correct branch and feeds. 
 Finally it also helps to provide some boot-strapped configuration for *MT7688*.
 It additionally copies the configuration files needed to make the setup for 
 secure access-point.
 The user has an option to set further configuration if needed. After completion
 it executes the next script `4_build.sh`.
 * **[`4_build.sh`][10]** = This initiates the various build steps. It helps to
 create the final Linux image. Also, copies the image file such that the 
 *Linkit Smart 7688 board* can be loaded using USB drive. Note that this
 would take a significant time depending on your config and number of cores
 in the host machine. Finally this script would enter a `bash` shell inside
 the container to allow user to do further customization if needed.

Hence to begin the build just use:

```shell
./1_start-shell.sh
```

**Note:** Default configuration is already available in `config.mt7688` file.
This is used to expand a full configuration before running build. Its just for
convenience to help new users.

There are a few additional script that are either redundant or used for other
development purposes.

 * ~~**[`2_install_dependencies.sh`][11]**~~ This was initially used to install
 build dependencies in the Host if needed. Since the build is done inside a 
 container, we no longer use this file.
 * **[`dropto_dev_shell.sh`][12]** - This would build the docker image if it
 does not exists. Then drop to a shell interface in the build image.
 * **[`only_get_sources.sh`][13]** - This provides a way to obtain the sources
 for *OpenWRT* and switch to correct branch. It also adjusts the feed 
 configuration and installs the respective packages. However it does not 
 set the Build configuration and the user is free to choose. Its important to 
 note that this script can and should only be run inside the docker container.
 Else it would fail.

**Note:** The location for the storage of the *OpenWRT* source and build are
still the present working directory in the Host. Hence make sure you have 
enough disk space available on the Host (minimum 10GByte).

### WiFi Password for default AP `OpenWrt` is **`Password`**

**Note:** The setup of files actually configures the default AP as **`OpenWrt`**.
The **Access Point** network is *WPA Personal PSK2* type. 
And *AP Password* is by default set to **`Password`**.

You can change this by edit the `/etc/config/wireless` or directly modify it here in the `files` folder.

### Adding USB Storage Support .aka. Pendrive / Jump-drive .etc.:

It's easy add USB Support during the build.

In the **`6.`** step during execution of **`3_Get_Sources.sh`** you would be asked 

`Continue with only Default config (y/n) [y] ? `

Just answer **'n'** there and Press Enter to start the **Configuration**.

You would now enter the configuration screen:

![OpenWrt Build Configuration Screen][14]

In order to navigate use the following keys:

 * 'Arrow keys' to Move around
 * 'Space Bar' to Select a module. Note that first it would be 'M' this is modularized.
 Its best to have the things built into the image. 
 Hence keep pressing space bar to get  the `*`. This means that the module is selected
 * 'Enter' to select a specific menu
 * 'Esc' x2 times to exit from menu or configuration screen. 
 You might need to hit it multiple times to exit the configuration program.
 * 'Tab' to select between Options

Perform the Following Selection :

```shell

## Add Block Mount support (Press Space 2 times to make it a Built In '*')
Base system ---> 
<*> block-mount........................... Block device mounting
## Press Esc x2 times to exit and go back to main menu

## Next Kernel Support for USB and File Systems
Kernel modules ---> Filesystems --->
<*> kmod-fs-ext4..................................... EXT4 filesystem support
<*> kmod-fs-ntfs..................................... NTFS filesystem support
<*> kmod-fs-vfat..................................... VFAT filesystem support
## Press Esc x2 times to exit and go back to Kernel modules menu

USB Support ---> 
-*- kmod-usb-storage..................................... USB Storage support
<*> kmod-usb-storage-extras.................... Extra drivers for usb-storage
## Press Esc x2 times to exit and go back to Kernel modules menu
## Press Esc x2 times to exit and go back to main menu

## Add LuCI Support
LuCI ---> 1. Collections  --->
<*> luci................... LuCI interface with Uhttpd as Webserver (default)
## Press Esc x2 times to exit and go back to LuCI Menu
## Press Esc x2 times to exit and go back to main menu

## Add USB Utilities
Utilities  --->
<*> usbutils................................... USB devices listing utilities
## Press Esc x2 times to exit and go back to main menu

## Finally Press Esc x2 times to exit Configuration menu
## You would be asked if 'Do you wish to save your new configuration?'
## Just select '< Yes >' by Tab and then Press Enter

```
Thats it the build would begin normally.

## Using the Build Output

The generated file **`lks7688.img`** might not have the correct permissions.

```shell
sudo chown $USER lks7688.img
```

Without this the file can't be used normally. 

Next would be copy this file to a FAT32 formatted pendrive.

Finally after connecting the pendrive to the **LinkItSmart 7688** here is the button Sequence:

1. Press & Hold the `WiFi Reset` Button
2. Press and Release `MPU Reset` button while holding the `WiFi Reset`
3. Wait for the **Orange LED** on the board to Turn ON and then OFF afte 5 seconds
4. Finally after 5Second of holing the `WiFi Reset` the **Orange LED** goes off and you can release the `WiFi Reset`
5. **Orange LED** would turn ON and start blinking. - This means that the new firmware is being flashed.
6. Connect a serial monitor to see the boot of the system.

For more info look on this procedure:

https://docs.labs.mediatek.com/resource/linkit-smart-7688/en/tutorials/firmware-and-bootloader/update-the-firmware-with-a-usb-drive

![Steps for USB Booloading of the LinkIt Smart 7688][15]





 [1]:https://www.seeedstudio.com/LinkIt-Smart-7688-p-2573.html
 [2]:LinkIt-Smart-7688-feature-picture.jpg
 [3]:https://openwrt.org/
 [4]:https://labs.mediatek.com/en/chipset/MT7688
 [5]:https://github.com/openwrt/openwrt/tree/v18.06.2
 [6]:https://downloads.openwrt.org/releases/18.06.2/targets/ramips/mt76x8/
 [7]:https://github.com/boseji/dockerPlayground/tree/master/14_OpenWRT-Docker-MT7688-build/Dockerfile
 [8]:https://github.com/boseji/dockerPlayground/tree/master/14_OpenWRT-Docker-MT7688-build/1_start-shell.sh
 [9]:https://github.com/boseji/dockerPlayground/tree/master/14_OpenWRT-Docker-MT7688-build/3_Get_Sources.sh
 [10]:https://github.com/boseji/dockerPlayground/tree/master/14_OpenWRT-Docker-MT7688-build/4_build.sh
 [11]:https://github.com/boseji/dockerPlayground/tree/master/14_OpenWRT-Docker-MT7688-build/2_install_dependencies.sh
 [12]:dropto_dev_shell.sh
 [13]:only_get_sources.sh
 [14]:make-menuconfig.png
 [15]:https://docs.labs.mediatek.com/resource/linkit-smart-7688/files/en/3145742/3145741/2/1469437979060/firmware+upgrade+LED+status.png
