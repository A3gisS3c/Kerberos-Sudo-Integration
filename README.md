# Kerberos-Sudo-Integration

Tired of typing your passwords 2000 times a day? Let me save your programmer fingers by integrating Kerberos with Sudo authentication. If you have already integrated Kerberos with your SSH authentication using the SSSD daemon, you will only need to type your password once during the validity period of your TGT (4 hours for a secure configuration).

Please note that the sample configuration files assume that SSH authentication with SSSD is already in place.

## How it works

![Screen](/screenshots/Kerberos-sudo.jpg)

## Requirements
- krb5-user >= 1.19
- pam_sss_gss.so (SSSD)

Tested on Debian 12 (bookworm)

## Configuration

There are sample files available in the samples/ directory on GitHub. Take a look at them to see where to place the configurations below.

1. /etc/ssh/sshd_config

```sh
...
UsePam yes
...
```

2. /etc/pam/pam.d/sshd (A script that will be triggered by pam_exec each time SSH is invoked)

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

5. /usr/local/bin/krb5-sudo.sh (chmod 400 && owner root)
```sh
#! /bin/bash
# Let PAM uses S4U2Self ticket for incomming user in order to authenticate sudo through GSSAPI
# DO NOT FORGET TO REPLACE <REALM> bellow with your REALM 
#
# Check PAM - sshd for acquisition/destroy - sudo & sudo-i for use
# chmod 700

if [ "$PAM_TYPE" = "open_session" ]; then
    kinit -c /tmp/krb5cc_host -k
    kvno -c /tmp/krb5cc_host -I "$PAM_USER"@<REALM> host/$(hostname -f) --out-cache /tmp/krb5cc_$(id -u "$PAM_USER")
    chown "$PAM_USER":"$PAM_USER" /tmp/krb5cc_$(id -u "$PAM_USER")
elif [ "$PAM_TYPE" = "close_session" ]; then
    if [[ -f /tmp/krb5cc_$(id -u "$PAM_USER") ]]; then
        kdestroy -c /tmp/krb5cc_$(id -u "$PAM_USER")
    fi
fi
```

6. /etc/nsswitch.conf
```sh
...
sudoers:        files sss
...
```

7. /etc/sssd/sssd.conf
```sh
...
[pam]
pam_gssapi_services = sudo, sudo-i
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





