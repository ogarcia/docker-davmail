# DavMail docker [![CircleCI](https://circleci.com/gh/ogarcia/docker-davmail.svg?style=svg)](https://circleci.com/gh/ogarcia/docker-davmail)

(c) 2018-2020 Óscar García Amor

Redistribution, modifications and pull requests are welcomed under the terms
of GPLv3 license.

[DavMail][1] is a POP/IMAP/SMTP/Caldav/Carddav/LDAP exchange gateway
allowing users to use any mail/calendar client with an Exchange server, even
from the internet or behind a firewall through Outlook Web Access.

This docker packages **DavMail** under [Alpine Linux][2], a lightweight
Linux distribution.

Visit [Docker Hub][3] or [Quay][4] to see all available tags.

[1]: http://davmail.sourceforge.net/
[2]: https://alpinelinux.org/
[3]: https://hub.docker.com/r/connectical/davmail/
[4]: https://quay.io/repository/connectical/davmail/

## Run

To run this container, simply exec.

```sh
docker run -d \
  --name=davmail \
  -p 1025:1025 \
  -p 1389:1389 \
  -p 1110:1110 \
  -p 1143:1143 \
  -p 1080:1080 \
  connectical/davmail
```

Default config points to [Office 365 EWS][5].

[5]: https://outlook.office365.com/EWS/Exchange.asmx

## Volumes

If you want reconfigure DavMail with your own `davmail.properties` you can
mount it as a volume.

```sh
docker run -d \
  --name=davmail \
  -v /my/own/davmail.properties:/etc/davmail/davmail.properties \
  connectical/davmail
```

In the same way you can configure a volume to persistent store the logs.

```sh
docker run -d \
  --name=davmail \
  -v /my/own/davmail/logdir:/var/log/davmail
  connectical/davmail
```

Take note that DavMail is running by `davmail` user (*UID 100*) inside
Docker. You must set proper permissions in your external volume to allow to
this user to write on it.

## Shell run

If you can run a shell instead DavMail, simply do.

```sh
docker run -t -i --rm \
  --name=davmail \
  --user=root \
  --entrypoint=/bin/sh \
  connectical/davmail
```

Please note that the `--rm` modifier destroy the docker after shell exit.
