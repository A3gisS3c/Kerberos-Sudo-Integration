# Kerberos-Sudo-Integration

Courte description.

## How it works

![Screen](/screenshots/Kerberos-sudo.jpg)

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
MIT License

Kerberos-Sudo-Integration
Copyright (c) 2024 Bruno Bettuzzi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.





