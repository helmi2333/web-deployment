#!/bin/bash

gen_cert() {
  if [[ ! -d "/etc/letsencrypt/live/$2" ]]; then
    /opt/letsencrypt/letsencrypt-auto certonly --webroot -w "$1" -d "$2" --renew-by-default --email kev@inburke.com --text --agree-tos
  fi
}

main() {
  gen_cert /home/twentyms/vrusability/public vrusability.com
  gen_cert /home/twentyms/vrusability/public www.vrusability.com
  gen_cert /home/twentyms/vrusability/public twentymilliseconds.com
  gen_cert /home/twentyms/vrusability/public 20milliseconds.net
  gen_cert /home/twentyms/vrusability/public www.20milliseconds.net
  gen_cert /home/twentyms/vrusability/public twentymilliseconds.net
  gen_cert /home/twentyms/vrusability/public www.twentymilliseconds.net
  gen_cert /home/twentyms/vrusability/public 20ms.net
  gen_cert /home/twentyms/vrusability/public www.20ms.net
  gen_cert /home/tarbz2/public tarbz2.com
  gen_cert /home/tarbz2/public www.tarbz2.com
  gen_cert /home/doony/doony jenkins.doony.org
  gen_cert /home/doony/doony www.doony.org
  gen_cert /home/doony/doony doony.org
  gen_cert /home/athenian/public athenian.me
  gen_cert /home/athenian/public athenian.me
}

main "$@"
