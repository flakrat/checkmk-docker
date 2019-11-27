# checkmk-docker
Scripts used for my Dockerized CheckMK site

## docker-checkmk-backup.sh
This is a script that I use via Cron to backup the CheckMK `/omd/sites` directory from within the Docker container

The script takes two mandatory arguments:
```shell
 -c | --container=<NAME>   = CheckMK Docker Container Name
 -d | --dest=<PATH>        = Destination path for the backup
```

Example:
```shell
$ ~/bin/docker-checkmk-backup.sh -c monitoring -d /backups/CheckMK
```

