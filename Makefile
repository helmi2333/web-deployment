ping:
	ANSIBLE_NOCOWS=1 ANSIBLE_HOSTS="$$PWD/hosts" ansible -m ping droplets

bootstrap:
	ANSIBLE_NOCOWS=1 ANSIBLE_HOSTS="$$PWD/hosts" ansible droplets --sudo -m raw -a "apt-get install -y python2.7 && ln -s /usr/bin/python2.7 /usr/bin/python"

website:
	ANSIBLE_KEEP_REMOTE_FILES=1 ANSIBLE_NOCOWS=1 ANSIBLE_HOSTS="$$PWD/hosts" ansible-playbook website.yml

copy-certs:
	mkdir -p certs
	rsync --checksum --human-readable --archive --verbose --compress --perms \
		--stats wildebeest-root:/etc/letsencrypt/ certs/
