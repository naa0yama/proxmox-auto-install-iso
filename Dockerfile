FROM debian:bookworm-slim@sha256:7e490910eea2861b9664577a96b54ce68ea3e02ce7f51d89cb0103a6f9c386e0

RUN set -eux \
    && apt-get -y update \
    && apt-get install -y --no-install-recommends \
    aria2 \
    bash \
    ca-certificates \
    curl \
    xorriso

SHELL [ "/bin/bash", "-c" ]
RUN <<-EOF
set -eux

mkdir -p /etc/apt/trusted.gpg.d
curl -sfSL https://enterprise.proxmox.com/debian/proxmox-release-bookworm.gpg \
    -o /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg

mkdir -p /etc/apt/sources.list.d
cat <<- _DOC_ > /etc/apt/sources.list.d/pve-no-subscription.list
deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg] http://download.proxmox.com/debian/pve $(. /etc/os-release && echo "$VERSION_CODENAME") pve-no-subscription

_DOC_

EOF

RUN set -eux \
    && apt-get -y update \
    && apt-get install -y --no-install-recommends \
    proxmox-auto-install-assistant

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["bash"]
CMD ["/entrypoint.sh"]
