# Dockerfile for ISC BIND DNS servers

# Build with:
# docker build -t "dns" .

# Run with:
# docker run -d -p 53:53 --name my-dns dns

# Alpine OS 3.5
# http://dl-cdn.alpinelinux.org/alpine/v3.5/community/x86_64/
FROM alpine:3.5

MAINTAINER Alexey Aksenov <ezh@ezh.msk.ru>

ARG version=9-10-5
ARG cflags="-O2 -m64"
ARG bind_dir="/opt/bind"
ARG build_config="--enable-largefile \
                   --enable-fixed-rrset \
                   --enable-filter-aaaa \
                   --enable-ipv6 \
                   --enable-threads \
                   --enable-rpz-nsip \
                   --enable-rpz-nsdname \
                   --enable-fetchlimit \
                   --enable-linux-caps \
                   --disable-symtable \
                   --with-readline=no \
                   --with-libtool \
                   --with-randomdev=/dev/random \
                   --sysconfdir=/etc/bind \
                   --with-openssl \
                   --with-libxml2 \
                   --with-gssapi \
                   --mandir=/usr/share/man \
                   --infodir=/usr/share/info \
                   --sysconfdir=${bind_dir}/etc \
                   --prefix=${bind_dir}"
                   #--enable-rrl \
                   # --with-idn=$idnlib_dir"
ARG bind_user_id=1000

COPY entrypoint.sh /
COPY bind/ /opt/bind/etc/

RUN apk add --no-cache bash gcc curl tar file wget shadow libcap libcap-dev \
        alpine-sdk linux-headers libxml2 libxml2-dev openssl openssl-dev \
        expat libacl libatomic libattr libedit libgcc            `#explicit subdependencies` \
        libstdc++ lzo pcre pkgconf xz-libs libressl libsmartcols `#explicit subdependencies` && \
        addgroup -g ${bind_user_id} bind && \
        adduser -s /bin/false -S -D -H -h "${bind_dir}" -u ${bind_user_id} -G bind bind && \
        mkdir -p "${bind_dir}/build" && \
        wget --no-check-certificate -O bind-${version}.tar.gz https://www.isc.org/downloads/file/bind-${version}/?version=tar-gz && \
        tar xzf bind-${version}.tar.gz  -C "${bind_dir}/build" --strip-components=1 && rm -rf bind-${version}.tar.gz && \
        cd "${bind_dir}/build" && ./configure CFLAGS="${cflags}" ${build_config} && make clean && make && make install && \
        chown -R bind:bind "${bind_dir}" && rm -rf "${bind_dir}/build" && \
        apk del gcc alpine-sdk linux-headers libxml2-dev openssl-dev libcap-dev && \
        rm -rf "/var/cache/apk/*" && chmod a+x /entrypoint.sh

RUN setcap 'cap_net_bind_service=+ep' /opt/bind/sbin/named

ENV PATH /opt/bind/bin:/opt/bind/sbin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

EXPOSE 53 953

ENTRYPOINT [ "/entrypoint.sh" ]

VOLUME [ "/opt/bind" ]

USER bind

WORKDIR ${bind_dir}

CMD ["named", "-g"]

