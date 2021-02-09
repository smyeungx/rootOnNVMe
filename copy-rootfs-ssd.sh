#!/bin/bash

# Check SD card and NVME mountpoint
SD_MOUNTPOINT=$(findmnt /dev/mmcblk0p1  --output=target -n)
NVME_MOUNTPOINT=$(findmnt /dev/nvme0n1p1 --output=target -n)

# If SD card is mounted as / and NVME is not mounted
# sync SD card to NVME
if [ "$SD_MOUNTPOINT" == "/" ] && [ -z "$NVME_MOUNTPOINT" ]; then
	echo "rsync SD card to NVME"
	# Mount the SSD as /mnt
	sudo mount /dev/nvme0n1p1 /mnt
	# Copy over the rootfs from the SD card to the SSD
	sudo rsync -axHAWX --numeric-ids --info=progress2 --exclude={"/dev/","/proc/","/sys/","/tmp/","/run/","/mnt/","/media/*","/lost+found"} / /mnt
	# We want to keep the SSD mounted for further operations
	# So we do not unmount the SSD
fi

# If NVME is mounted as / and SD card mounted 
# sync NVME to SD card
if [ "$NVME_MOUNTPOINT" == "/" ]; then
	echo "rsync NVME to SD card"
	# If SD card is not mounted, mount it
	if [ -z "$SD_MOUNTPOINT" ]; then
		SD_MOUNTPOINT="/mnt/sdcard"
		sudo mkdir "$SD_MOUNTPOINT"
		sudo mount /dev/mmcblk0p1 "$SD_MOUNTPOINT"
	fi
	sudo rsync -axHAWX --numeric-ids --info=progress2 --exclude={"/dev/","/proc/","/sys/","/tmp/","/run/","/mnt/","/media/*","/lost+found"} / "$SD_MOUNTPOINT"
fi
