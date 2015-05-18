#!/bin/sh

IMG=debian-8.0.0-openstack-amd64.qcow2
IMG_URL=http://cdimage.debian.org/cdimage/openstack/current/$IMG

TMP_DIR=/tmp/debian-jessie-guest

wget $IMG_URL

if [ ! -d "$TMP_DIR" ]; then
    sudo mkdir $TMP_DIR
fi

sudo guestmount -a $IMG -i $TMP_DIR

sudo sed -i "s#name: debian#name: cloud#" $TMP_DIR/etc/cloud/cloud.cfg
sudo sed -i "s#gecos: Debian#gecos: Cloud user#" $TMP_DIR/etc/cloud/cloud.cfg
sudo sed -i "s#debian#cloud#" $TMP_DIR/etc/sudoers.d/debian-cloud-init
sudo sed -i "#ed25519#d" $TMP_DIR/etc/ssh/sshd_config
# install haveged package
sudo sed -i "/gecos/a \ \ \ \ \ shell: \/bin\/bash" $TMP_DIR/etc/cloud/cloud.cfg
sudo guestunmount $TMP_DIR

glance image-create \
       --file $IMG \
       --disk-format qcow2 \
       --container-format bare \
       --name 'Debian Jessie'

#glance image-update --property cw_os=Ubuntu --property cw_origin=
#Cloudwatt --property hw_rng_model=virtio --min-disk 10 --is-public
#True --purge-props d2df7857-c81f-4789-ae75-5f86f0f55fa2
