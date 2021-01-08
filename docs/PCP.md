#Performance Co-Pilot Quick Note

## Dumptext with standar time stamp:
```bash
pmdumptext -Xlimu -f %FT%T -t1 disk.partitions.write[vdb1] \ 
disk.partitions.read[vdb1] disk.partitions.read_bytes[vdb1] \ 
disk.partitions.write_bytes[vdb1] filesys.used[/dev/vdb1] filesys.usedfiles[/dev/vdb1]
```