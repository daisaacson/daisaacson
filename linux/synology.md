# synology

## Snapshot replication

### Remote

```bash
mnt="/mnt"
sudo cryptsetup luksOpen /dev/sdb1 nvme
sudo mount -o noatime,lazytime,discard=async,compress-force=zstd:1,space_cache=v2,x-systemd.device-timeout=0 /dev/mapper/nvme ${mnt}

server="nas"
tag="WD750"
dst="${mnt}/backups/${server}"
# Bootstrap
#ssh ${server} sudo btrfs send --without-syno-features "${subvol}/${new}" | pv | sudo btrfs receive "${dst}/${snapshot}/"

for snapshot in homes photo; do
  echo "== ${snapshot} =="
  # get sudo to password, so it's not burried in pipeline output
  sudo ls ${dst}
  # subvolume path
  share=$(ssh ${server} sudo /usr/syno/sbin/synoshare --get-real-path ${snapshot})
  snappath=$(ssh ${server} sudo /usr/syno/sbin/synobtrfssnap -w $share | tail -1)
  subvol="${snappath%/}/${share#/*/}"
  # prevous snapshot ID
  old=$(ssh ${server} sudo /usr/syno/sbin/synosharesnapshot list ${snapshot} desc=${tag} lock=true | tail -1)
  # create a new snapshot
  ssh ${server} sudo /usr/syno/sbin/synosharesnapshot create ${snapshot} desc=${tag} lock=true
  new=$(ssh ${server} sudo /usr/syno/sbin/synosharesnapshot list ${snapshot} desc=${tag} lock=true | tail -1)
  # send delta to backup device
  ssh ${server} sudo btrfs send --without-syno-features -p "${subvol}/${old}" "${subvol}/${new}" | pv | sudo btrfs receive "${dst}/${snapshot}/"
  # untag old snapshot
  if [ $(( $? )) -eq 0 ]; then
    ssh ${server} sudo /usr/syno/sbin/synosharesnapshot attr set ${snapshot} ${old} desc="" lock=false
  fi
done
```

### Backup usage

```bash
for snapshot in homes photo; do
  sudo btrfs filesystem du -s ${dst}/${server}/${snapshot}/*
done
```
