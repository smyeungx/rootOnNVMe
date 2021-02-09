#!/bin/bash

SD_DEV="/dev/mmcblk0p1"
NVME_DEV="/dev/nvme0n1p1"

# Check SD card and NVME mountpoint
SD_MOUNTPOINT=$(findmnt /dev/mmcblk0p1  --output=target -n)
NVME_MOUNTPOINT=$(findmnt /dev/nvme0n1p1 --output=target -n)

# If SD card is mounted as / and NVME SSD is not mounted
# sync SD card to NVME SSD
if [ "$SD_MOUNTPOINT" == "/" ] && [ -z "$NVME_MOUNTPOINT" ]; then
	echo "rsync SD card to NVME SSD"
	# Mount the SSD as /mnt
	NVME_MOUNTPOINT="/mnt"
	sudo mount "$NVME_DEV" "$NVME_MOUNTPOINT"
	# Copy over the rootfs from the SD card to the NVME SSD
	sudo rsync -axHAWX --numeric-ids --info=progress2 --exclude={"/dev/","/proc/","/sys/","/tmp/","/run/","/mnt/","/media/*","/lost+found"} / "$NVME_MOUNTPOINT"
	# We want to keep the SSD mounted for further operations
	# So we do not unmount the SSD
fi

# If NVME SSD is mounted as / and SD card mounted 
# sync NVME SSD to SD card
if [ "$NVME_MOUNTPOINT" == "/" ]; then
	echo "rsync NVME SSD to SD card"
	# If SD card is not mounted, mount it
	if [ -z "$SD_MOUNTPOINT" ]; then
		SD_MOUNTPOINT="/mnt/sdcard"
		sudo mkdir "$SD_MOUNTPOINT"
		sudo mount "$SD_DEV" "$SD_MOUNTPOINT"
	fi
	# Copy over the rootfs from the NVME SSD to the SD card
	sudo rsync -axHAWX --numeric-ids --info=progress2 --exclude={"/dev/","/proc/","/sys/","/tmp/","/run/","/mnt/","/media/*","/lost+found"} / "$SD_MOUNTPOINT"
fi
