# VM Conversion

## VMDK to RAW
Même chose pour un VDI
```
VBoxManage clonehd <file.vmdk> <file.raw> --format RAW
```
ou
```
qemu-img convert -f vmdk -O raw image.vmdk image.img
```

## VMDK to VDI
```
VBoxManage clonehd --format VDI <file.vmdk> <file.vdi>
```
ou
```
qemu-img convert -f vmdk -O vdi <file.vmdk> <file.vdi>
```

## RAW to VMDK
Mêmme chose pour un VDI
```
VBoxManage convertdd <file.raw> <file.vmdk> --format VMDK
```
ou
```
qemu-img convert -f raw -O vmdk <file.img> <file.vmdk>
```

## HDS to DD (Parallels format)
```
qemu-img convert -f parallels -O raw <file.hds> <file.dd>
```

## VMA.LZO to RAW (Proxmox format)
Liste des paquets nécessaires : https://www.liberasys.com/wiki/doku.php?id=proxmox-extract-backup:proxmox_extract_backup

Décompresser le fichier 
```
lzop -x <file.vma.lzop>
```

Lister les fichiers
```
vma list <file.vma>
```

Extraire les fichiers dans le répertoire voulu
```
vma extract -v <file.vma> <dir>
```

Convertir le RAW en VID (si besoin)
```
qemu-img convert -p -f raw -O vdi <file.raw> <file.vdi>
```

