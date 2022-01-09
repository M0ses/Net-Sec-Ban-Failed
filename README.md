# ban_failed - monitor logs/update configs

**ATTENTION: This is just a proof of concept (POC)! This project is not for productive use!**

## The Idea:

* monitor your centralized log files for security relevant incidences
* update your configs in real time
* keep track of changes via VCS (e.g. git)
* deploy updated configs via your preferred configuration management (e.g. salt, puppet, ansible)


## How it works (or better - should work)

* Configure your POSTFIX/COURIER-IMAP server to log to your salt master via [systemd-journal-upload](https://www.freedesktop.org/software/systemd/man/systemd-journal-upload.service.html)
* Configure ban_failed (/etc/ban_failed/config.yml) on your salt master
  * to read from the remote log 
    * (journaltctl -f /var/log/journal/remote/...) is your friend
  * configure the proper outputfile (e.g. /srv/salt/mail/abuse)
  * configure your firewall to read the file where you want to deploy /srv/salt/mail/abuse
  * configure salt to deploy /srv/salt/mail/abuse on your firewall(s) and restart your firewall(s)

## FUTURE/TODO

* Implement more services (e.g. apache/nextcloud/sshd/etc.)
* Implement more log types
* ...
