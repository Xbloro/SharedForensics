# VM Convertion

## VMA.LZO to RAW (Proxmox format)

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
