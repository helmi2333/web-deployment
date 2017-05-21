## Creating a new Droplet

Create a new SSH key in `~/.ssh`. Name it `name_rsa`

```
$ ssh-keygen -o -a 100 -t ed25519 -f name_rsa
```

Edit `.ssh/config` and add the new server's hostname.

```
Host wildebeest
    HostName x.y.z.w
    IdentityFile ~/.ssh/name_rsa
    KeepAlive yes
    User root
```

You should be able to SSH in!

You'll want to install Python 2.7 on the remote Ubuntu instance, and symlink
it. Run `make bootstrap` to accomplish this.

If you rebuild the server from the original, you might need to delete the key
from `~/.ssh/known_hosts`.

## SSH Keys

Each machine you deploy from should have deploy keys. Generate them with
ssh-keygen:

```
ssh-keygen -o -a 100 -t ed25519 -f ssh-keys/inburke.com/resume_rsa
```

Then upload the deploy key to the correct repository. (Unfortunately the _rsa
suffix is there because the first keys were RSA keys).

## Initial host configuration

You might need to add the following line to `/etc/sudoers.d/ubuntu`

```
ubuntu ALL=(ALL) NOPASSWD: ALL
```

Explanation: http://toroid.org/sudoers-syntax

## Ansible Vault
