ping:
	ANSIBLE_NOCOWS=1 ANSIBLE_HOSTS="$$PWD/hosts" ansible -m ping droplets

bootstrap:
	ANSIBLE_NOCOWS=1 ANSIBLE_HOSTS="$$PWD/hosts" ansible droplets --sudo -m raw -a "apt-get install -y python2.7 python-mysqldb && ln -s /usr/bin/python2.7 /usr/bin/python || true"

website:
	ANSIBLE_NOCOWS=1 ANSIBLE_HOSTS="$$PWD/hosts" \
		ansible-playbook website.yml \
		--vault-password-file=passwords/ansible-vault.password

common:
	ANSIBLE_NOCOWS=1 ANSIBLE_HOSTS="$$PWD/hosts" \
		ansible-playbook common.yml \
		--vault-password-file=passwords/ansible-vault.password

copy-certs:
	mkdir -p certs
	rsync --checksum --human-readable --archive --verbose --compress --perms \
		--stats wildebeest-root:/etc/letsencrypt/ certs/

fsm:
	ANSIBLE_NOCOWS=1 ANSIBLE_HOSTS="$$PWD/hosts" ansible-playbook fsm.yml

matto:
	ANSIBLE_NOCOWS=1 ANSIBLE_HOSTS="$$PWD/hosts" ansible-playbook mattokazaki.com.yml

jackpiels:
	ANSIBLE_NOCOWS=1 ANSIBLE_HOSTS="$$PWD/hosts" ansible-playbook jackpiels.com.yml \
		--vault-password-file=passwords/ansible-vault.password

laura:
	ANSIBLE_NOCOWS=1 ANSIBLE_HOSTS="$$PWD/hosts" ansible-playbook laurakashiwase.com.yml

nate:
	ANSIBLE_NOCOWS=1 ANSIBLE_HOSTS="$$PWD/hosts" ansible-playbook natewinslow.com.yml

tarbz2:
	ANSIBLE_NOCOWS=1 ANSIBLE_HOSTS="$$PWD/hosts" \
		ansible-playbook tarbz2.com.yml \
		--vault-password-file=passwords/ansible-vault.password

goodmorningcmc:
	ANSIBLE_NOCOWS=1 ANSIBLE_HOSTS="$$PWD/hosts" \
		ansible-playbook goodmorningcmc.inburke.com.yml \
		--vault-password-file=passwords/ansible-vault.password


letsencrypt:
	ANSIBLE_NOCOWS=1 ANSIBLE_HOSTS="$$PWD/hosts" \
		ansible-playbook letsencrypt.yml \
		--vault-password-file=passwords/ansible-vault.password

stage:
	ANSIBLE_NOCOWS=1 ANSIBLE_HOSTS="$$PWD/hosts" \
		ansible-playbook stage.inburke.com.yml \
		--vault-password-file=passwords/ansible-vault.password

kev.inburke.com:
	ANSIBLE_NOCOWS=1 ANSIBLE_HOSTS="$$PWD/hosts" \
		ansible-playbook prod.inburke.com.yml \
		--vault-password-file=passwords/ansible-vault.password

brianburke:
	ANSIBLE_NOCOWS=1 ANSIBLE_HOSTS="$$PWD/hosts" \
		ansible-playbook brianburke.net.yml \
		--vault-password-file=passwords/ansible-vault.password

athenian.me:
	ANSIBLE_NOCOWS=1 ANSIBLE_HOSTS="$$PWD/hosts" \
		ansible-playbook athenian.me.yml \
		--vault-password-file=passwords/ansible-vault.password

kevin:
	ANSIBLE_NOCOWS=1 ANSIBLE_HOSTS="$$PWD/hosts" \
		ansible-playbook kevin.yml \
		--vault-password-file=passwords/ansible-vault.password
