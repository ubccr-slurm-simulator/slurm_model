#Slurm system administration quick note

## Add Account
```bash
   sacctmgr add Account <acountName> Description = <text> Organization = <text>
```

## Add user
```bash
    sacctmgr add user <userName> DefaultAccount = <accountName>
```

## Show Account
```bash
    ssactmgr show account
```

## Modify 
```bash
    ssactmgr modify association where user = <userName> account = <accountname> <cmd>
```

```bash
scontrol update NodeName=compute000 State=RESUME
```
sacctmgr list associations format=Account,Cluster,User,Fairshare tree withd
scontrol show assoc