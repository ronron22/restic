# Restic

https://jpmens.net/2017/08/22/my-backup-software-of-choice-restic/

conseils :
* utilisez les tags pour marquer les backups

dans mon cas, les deux mots de passe s'expliquent ainsi :
* un pour le chiffrement/déchiffrement des données
* l'autre pour l'accès web Rest server

## Restic

### Installation

#### dépendances 

Installez fuse

```bash
apt install fuse
```

### configuration

#### déclarer un serveur restic

```bash
export REPO='rest:http://backup:truc@pouet.com:8000/sauvegarde'
export RESTIC_PASSWORD='truc'
```

### exploitation

#### initialisation 

```bash
restic -r $REPO init 
```

#### backup

```bash
restic -r $REPO backup /root/workspace/teste/tagada/
```

#### Les snapshots

##### visualiser ses snapshots

```bash
restic -r $REPO snapshots
```

##### restaurer un snapshot

```bash
restic -r $REPO restore c6fd29d9 --target /tmp/truc/
```

##### voir le delta de deux snapshot

```bash
restic -r $REPO diff 6ed3c283 1bf6f21e
password is correct
comparing snapshot 6ed3c283 to 1bf6f21e:

+    /cyrus/mail/a/user/antonio/27547.
+    /cyrus/mail/a/user/antonio/27548.
+    /cyrus/mail/a/user/antonio/27549.
```

##### suppression d'un snapshot

```bash
restic -r $REPO forget c6fd29d9
```
la suppression des données effectives se fera avec 

```bash
restic -r $REPO prune
```

Restic rebuildera alors un nouvel index (opération un peu longue, quelque minutes)

##### montage des snapshots et navigation dans la sauvegarde

```bash
restic -r $REPO mount /mnt
```
dans une autre console

```bash
 mount -t fuse
restic on /mnt type fuse (ro,nosuid,nodev,relatime,user_id=0,group_id=0)
```

### Les tags

A venir

## Rest server

Rest est le backend "S3" du projet restic

https://github.com/restic/rest-server

### exploitation

### naviguer dans le Rest-server

```bash
docker exec -it rest_server sh
```

## FAQ

### lock

```bash
~/restic# restic -r $REPO check
password is correct
create exclusive lock for repository
Fatal: unable to create lock in backend: repository is already locked by PID 7334 on localhost by root (UID 0, GID 0)
lock was created at 2018-04-01 23:18:51 (1h8m44.395671802s ago)
storage ID 6b3d5fa2
~# restic -r $REPO unlock
```

### config not found

```bash
unable to open config file: Stat: stat /data/restic/config: no such file or directory
Is there a repository at the following location?
```

Use "restic -r $REPO init" for initializing directory tree on restic backend
