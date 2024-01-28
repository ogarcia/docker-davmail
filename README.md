# DavMail container [![CircleCI](https://circleci.com/gh/ogarcia/docker-davmail.svg?style=svg)](https://circleci.com/gh/ogarcia/docker-davmail)

(c) 2018-2024 Óscar García Amor

Redistribution, modifications and pull requests are welcomed under the terms
of GPLv3 license.

[DavMail][1] is a POP/IMAP/SMTP/Caldav/Carddav/LDAP exchange gateway
allowing users to use any mail/calendar client with an Exchange server, even
from the internet or behind a firewall through Outlook Web Access.

This container packages **DavMail** under [Alpine Linux][2], a lightweight
Linux distribution.

Visit [Quay][3] or [GitHub][4] to see all available tags.

[1]: http://davmail.sourceforge.net/
[2]: https://alpinelinux.org/
[3]: https://quay.io/repository/connectical/davmail
[4]: https://github.com/orgs/connectical/packages/container/package/davmail

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
  ghcr.io/connectical/davmail
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
  ghcr.io/connectical/davmail
```

In the same way you can configure a volume to persistent store the logs.

```sh
docker run -d \
  --name=davmail \
  -v /my/own/davmail/logdir:/var/log/davmail
  ghcr.io/connectical/davmail
```

Take note that DavMail is running by `davmail` user (*UID 100*) inside
container. You must set proper permissions in your external volume to allow
to this user to write on it.

## Shell run

If you can run a shell instead DavMail, simply do.

```sh
docker run -t -i --rm \
  --name=davmail \
  --user=root \
  --entrypoint=/bin/sh \
  ghcr.io/connectical/davmail
```

Please note that the `--rm` modifier destroy the container after shell exit.
