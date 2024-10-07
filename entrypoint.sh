#!/usr/bin/env bash
set -eux

PROXMOX_VERSION=${PROXMOX_VERSION:-8.2-2}
PROXMOX_ISO_SHA=${PROXMOX_ISO_SHA:-c96ad84eacbbcef299ab8f407f9602f832abb5ceb08a9aa288c1e1164df2da97}

mkdir -p /answers /dist
cd /dist

if ! [ -f "/dist/proxmox-ve_${PROXMOX_VERSION}.iso" ]; then
    aria2c https://enterprise.proxmox.com/iso/proxmox-ve_${PROXMOX_VERSION}.iso
    echo "${PROXMOX_ISO_SHA}  proxmox-ve_${PROXMOX_VERSION}.iso" | sha256sum --status -c -
fi

for host in "10.2.21.201"
do
    proxmox-auto-install-assistant prepare-iso /dist/proxmox-ve_${PROXMOX_VERSION}.iso \
        --fetch-from iso --answer-file "/answers/${host}.toml" \
        --output "/dist/proxmox-ve_auto_${PROXMOX_VERSION}_${host}.iso"
done
