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

