# Kerberos-Sudo-Integration

Courte description.

## How it works

![Screen](/screenshots/Kerberos-sudo.jng)

## Requirements
- krb5-user >= 1.19
- pam_sss_gss.so (SSSD)

Tested on Debian 12 (bookworm)

## Configuration

There are sample files available in the sample/ directory on GitHub.
Take a look at them to see at which section to put configurations bellow.

1. /etc/ssh/sshd_config

```sh
...
UsePam yes
...
```

2. /etc/pam/pam.d/sshd (Script that will be triggered by pam_exec)

```sh
...
### Acquire S4U2Self host/FQDN ticket to use GSSAPI with SUDO. Group sudo mandatory.
session [default=1 success=ignore] pam_succeed_if.so user ingroup sudo
session optional pam_exec.so /usr/local/bin/krb5-sudo.sh
...
```

3. /etc/pam/pam.d/sudo
```sh
...
# Authenticate sudo through GSSAPI
auth sufficient pam_sss_gss.so
...
```

4. /etc/pam/pam.d/sudo-i
```sh
...
# Authenticate sudo through GSSAPI
auth sufficient pam_sss_gss.so
...
```

# License
YASD - Yet Another Sécurity Dashboard
Copyright (c) 2024 Bruno Bettuzzi

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see [http://www.gnu.org/licenses/](http://www.gnu.org/licenses/)





