#!/bin/bash

if [[ ${EUID} != 0 ]]; then
        echo This must be run as root!
        exit 1
fi

usb_dev_id=$(ls /sys/bus/usb/devices/ | grep -v ':\|usb\|\.')
for i in ${usb_dev_id}; do
        echo -e "Resetting USB device: ${i}"
        udevadm info -p /sys/bus/usb/devices/${i} | grep -E "ID_SERIAL"
        echo -n "${i}" > /sys/bus/usb/drivers/usb/unbind
        echo -n "${i}" > /sys/bus/usb/drivers/usb/bind
done
