FROM alpine:3.12

LABEL description "Simple DNS authoritative server with DNSSEC support" \
      maintainer="Veovis <veovis@kveer.fr>"

ARG NSD_VERSION=4.3.4
ENV UID=991 GID=991

RUN set -xe; \
   install -d /var/db/nsd -o 991 -g 991 -m 755; \
   addgroup -S -g $GID nsd; \
   adduser -S -D -h /var/db/nsd -G nsd -u $UID -g nsd nsd; \
   apk add --no-cache nsd ca-certificates openssl su-exec

   # https://pgp.mit.edu/pks/lookup?search=0x7E045F8D&fingerprint=on&op=index
# pub  4096R/7E045F8D 2011-04-21 W.C.A. Wijngaards <wouter@nlnetlabs.nl>
ARG GPG_SHORTID="0x7E045F8D"
ARG GPG_FINGERPRINT="EDFA A3F2 CA4E 6EB0 5681  AF8E 9F6F 1C2D 7E04 5F8D"
ARG SHA256_HASH="d17c0ea3968cb0eb2be79f2f83eb299b7bfcc554b784007616eed6ece828871f"

ENV UID=991 GID=991

COPY entrypoint.sh /sbin/entrypoint.sh
COPY bin /usr/local/bin
VOLUME /zones /etc/nsd /var/db/nsd
EXPOSE 53 53/udp
ENTRYPOINT [ "/sbin/entrypoint.sh" ]
CMD nsd -u $UID.$GID -P /tmp/nsd.pid -d
