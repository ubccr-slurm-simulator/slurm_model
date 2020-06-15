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

