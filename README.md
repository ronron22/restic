# Restic

https://jpmens.net/2017/08/22/my-backup-software-of-choice-restic/

Utilisez les tags pour marquer les backups

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
### Les tags

## Rest server

Rest est le backend "S3" du projet restic

https://github.com/restic/rest-server

### exploitation

### naviguer dans le Rest-server

```bash
docker exec -it rest_server sh
```
