## Creating a new Droplet

Create a new SSH key in `~/.ssh`. Name it `name_rsa`

```
$ ssh-keygen -t rsa -b 4096
Generating public/private rsa key pair.
Enter file in which to save the key (/Users/kevin/.ssh/id_rsa): wildebeest_rsa
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in wildebeest_rsa.
Your public key has been saved in wildebeest_rsa.pub.
The key fingerprint is:
5f:a8:c8:95:86:ca:4d:50:21:fd:8f:de:bc:b4:32:00 kevin@rhino
The key's randomart image is:
+---[RSA 4096]----+
|    ..o.         |
|     o.          |
|    .  .         |
|    E. ... .     |
|     .o So. .    |
|   . =.+.o..     |
|    o +o.oo      |
|        +.o.     |
|         oo.     |
+-----------------+
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
it. Run "make bootstrap" to accomplish this.

If you rebuild the server from the original, you might need to delete the key
from `~/.ssh/known_hosts`.
