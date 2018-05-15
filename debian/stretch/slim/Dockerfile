FROM debian:stretch-slim

LABEL maintainer="LisonFan <lisonfan1996@gmail.com>"

ENV PCAP_DNSPROXY_VERSION 0.4.9.5
ENV LIBSODIUM_VERSION 1.0.16
ENV TZ 'Asia/Shanghai'

RUN set -ex \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y \
    cmake \
    wget \
    openssl \
    libevent-dev \
    ca-certificates \
    g++ \
    gcc \
    make \
    libssl-dev \
    libpcap-dev \
    build-essential \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo $TZ > /etc/timezone \
    && ( cd /tmp \
    && wget -c -O libsodium.tar.gz https://github.com/jedisct1/libsodium/releases/download/1.0.16/libsodium-${LIBSODIUM_VERSION}.tar.gz \
    && tar zxf libsodium.tar.gz \
    && rm -rf libsodium.tar.gz \
    && cd libsodium-${LIBSODIUM_VERSION} \
    && ./configure --disable-maintainer-mode && make -j2 && make install \
    && echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf \
    && ldconfig ) \
    && rm -rf /tmp/libsodium-${LIBSODIUM_VERSION} \
    && ( cd /tmp \
    && wget -c -O Pcap_DNSProxy.tar.gz https://github.com/chengr28/Pcap_DNSProxy/archive/v${PCAP_DNSPROXY_VERSION}.tar.gz \
    && tar zxf Pcap_DNSProxy.tar.gz \
    && rm -rf Pcap_DNSProxy.tar.gz \
    && mv Pcap_DNSProxy-${PCAP_DNSPROXY_VERSION} Pcap_DNSProxy \
    && cd Pcap_DNSProxy/Source/Auxiliary/Scripts \
    && chmod 755 CMake_Build.sh \
    && ./CMake_Build.sh \
    && mv /tmp/Pcap_DNSProxy/Source/Release /pcap_dnsproxy \
    && rm -rf /tmp/Pcap_DNSProxy ) \
    && apt-get remove --purge --auto-remove -y \
    cmake \
    wget \
    g++ \
    gcc \
    make \
    build-essential \
    && rm -rf /var/lib/apt/lists/* 

WORKDIR /pcap_dnsproxy

ENTRYPOINT ["/pcap_dnsproxy/Pcap_DNSProxy", "--disable-daemon"]
