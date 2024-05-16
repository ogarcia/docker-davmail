# DavMail container

[![forthebadge](https://forthebadge.com/images/badges/built-with-resentment.svg)](https://forthebadge.com)
[![forthebadge](https://forthebadge.com/images/badges/its-not-a-lie-if-you-believe-it.svg)](https://forthebadge.com)
[![forthebadge](https://forthebadge.com/images/badges/contains-technical-debt.svg)](https://forthebadge.com)

(c) 2018-2024 Óscar García Amor

Redistribution, modifications and pull requests are welcomed under the terms
of GPLv3 license.

[DavMail][dm] is a POP/IMAP/SMTP/Caldav/Carddav/LDAP exchange gateway
allowing users to use any mail/calendar client with an Exchange server, even
from the internet or behind a firewall through Outlook Web Access.

This container packages **DavMail** under [Alpine Linux][al], a lightweight
Linux distribution.

Visit [Quay][qu] or [GitLab][gl] to see all available tags.

[dm]: http://davmail.sourceforge.net/
[al]: https://alpinelinux.org/
[qu]: https://quay.io/repository/connectical/davmail
[gl]: https://gitlab.com/connectical/container/davmail/container_registry

## Run

To run this container, simply exec.

```sh
alias docker="podman" # If you are using podman
docker run -d \
  --name=davmail \
  -p 1025:1025 \
  -p 1389:1389 \
  -p 1110:1110 \
  -p 1143:1143 \
  -p 1080:1080 \
  registry.gitlab.com/connectical/container/davmail
```

Default config points to [Office 365 EWS][o365].

[o365]: https://outlook.office365.com/EWS/Exchange.asmx

## Volumes

If you want reconfigure DavMail with your own `davmail.properties` you can
mount it as a volume.

```sh
alias docker="podman" # If you are using podman
docker run -d \
  --name=davmail \
  -v /my/own/davmail.properties:/etc/davmail/davmail.properties \
  registry.gitlab.com/connectical/container/davmail
```

In the same way you can configure a volume to persistent store the logs.

```sh
alias docker="podman" # If you are using podman
docker run -d \
  --name=davmail \
  -v /my/own/davmail/logdir:/var/log/davmail
  registry.gitlab.com/connectical/container/davmail
```

Take note that DavMail is running by `davmail` user (*UID 100*) inside
container. You must set proper permissions in your external volume to allow
to this user to write on it.

## Shell run

If you can run a shell instead DavMail, simply do.

```sh
alias docker="podman" # If you are using podman
docker run -t -i --rm \
  --name=davmail \
  --user=root \
  --entrypoint=/bin/sh \
  registry.gitlab.com/connectical/container/davmail
```

Please note that the `--rm` modifier destroy the container after shell exit.
