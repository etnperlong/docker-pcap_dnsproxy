FROM alpine:3.9

LABEL maintainer="Evans Mike <etnperlong@gmail.com>"

ARG TZ='Asia/Shanghai'

ENV TZ $TZ
ENV PCAP_DNSPROXY_VERSION 0.4.9.13

RUN apk upgrade --update \
    && apk add bash tzdata \
    && apk add --virtual .build-deps \
                                    wget \
                                    sed \
                                    cmake \
                                    build-base \
                                    libsodium \
                                    libsodium-dev \
                                    libpcap \
                                    libpcap-dev \
                                    openssl \
                                    openssl-dev \
                                    libevent \
                                    libevent-dev \
                                    linux-headers \
    && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && ( cd /tmp \
    && wget -c -O Pcap_DNSProxy.tar.gz https://github.com/chengr28/Pcap_DNSProxy/archive/v${PCAP_DNSPROXY_VERSION}.tar.gz \
    && tar zxf Pcap_DNSProxy.tar.gz \
    && rm -rf Pcap_DNSProxy.tar.gz \
    && mv Pcap_DNSProxy-${PCAP_DNSPROXY_VERSION} Pcap_DNSProxy \
    && sed -i "22a#define    fcloseall() (void)0"  Pcap_DNSProxy/Source/Pcap_DNSProxy/Platform.h \
    && cd Pcap_DNSProxy/Source/Auxiliary/Scripts \
    && chmod 755 CMake_Build.sh \
    && ./CMake_Build.sh \
    && cp /tmp/Pcap_DNSProxy/Source/Release/Pcap_DNSProxy /usr/bin/Pcap_DNSProxy \
	&& mkdir -p /etc/Pcap_DNSProxy \
	&& cp /tmp/Pcap_DNSProxy/Source/Release/*.txt /etc/Pcap_DNSProxy \
	&& cp /tmp/Pcap_DNSProxy/Source/Release/*.conf /etc/Pcap_DNSProxy \
    && rm -rf /tmp/Pcap_DNSProxy ) \
    && runDeps="$( \
        scanelf --needed --nobanner /usr/bin/Pcap_DNSProxy \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | xargs -r apk info --installed \
            | sort -u \
        )" \
    && apk add --virtual .run-deps $runDeps \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/*

ENTRYPOINT ["/usr/bin/Pcap_DNSProxy", "--config-path /etc/Pcap_DNSProxy", "--log-file stdout", "--disable-daemon"]
