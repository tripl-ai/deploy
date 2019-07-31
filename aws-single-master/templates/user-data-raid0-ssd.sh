#!/bin/bash
sudo mdadm --create --verbose /dev/md0 --raid-devices=4 --level=0 /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1 /dev/nvme4n1
sudo mkfs -t xfs /dev/md0
sudo mkdir /data
sudo mount /dev/md0 /data
