#!/bin/bash
vmware-hgfsclient | while read folder; do
  vmwpath="/mnt/hgfs/\${folder}"
  echo "[i] Mounting \${folder}   (\${vmwpath})"
  mkdir -p "\${vmwpath}"
  umount -f "\${vmwpath}" 2>/dev/null
  vmhgfs-fuse -o allow_other -o auto_unmount ".host:/\${folder}" "\${vmwpath}"
done
sleep 2s

# Lol
ln -sf /usr/local/sbin/mount-shared-folders /root/Desktop/mount-shared-folders.sh
gsettings set org.gnome.nautilus.preferences executable-text-activation 'ask'
