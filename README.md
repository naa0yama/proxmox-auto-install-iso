# proxmox-auto-install-iso
Create an automated installation ISO for Proxmox VE

```bash
docker build -t tmp .
docker run --rm -u $(id -u):$(id -g) -it -v $PWD/answers:/answers -v $PWD/dist:/dist tmp

```