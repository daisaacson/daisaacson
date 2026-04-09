# synology

## Snapshot replication

```bash
ssh nas sudo btrfs send --without-syno-features /volume1/\@sharesnap/\@photo\@/GMT-05-2026.04.08-21.25.26 | sudo btrfs receive -E0 backups/nas/phto/
```
