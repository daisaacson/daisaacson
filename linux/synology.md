# synology

## Snapshot replication

### Remote

```bash
server="nas"
tag="WD750"
dst="./backups/${server}"
# Bootstrap
#ssh ${server} sudo btrfs send --without-syno-features "${subvol}/${new}" | pv | sudo btrfs receive "${dst}/${snapshot}/"

for snapshot in homes photo; do
  echo "== ${snapshot} =="
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
  ssh ${server} sudo /usr/syno/sbin/synosharesnapshot attr set ${snapshot} ${old} desc="" lock=false
done
```
