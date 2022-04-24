FROM alpine:latest

ENV LISTENING_PORT=7654
ENV ARGUMENTS=""

EXPOSE ${LISTENING_PORT}

RUN BUILD_DEPENDENCIES=" \
        build-base \
        git \
        linux-headers \
        openssl-dev \
    "; set -x \
    && apk add ${BUILD_DEPENDENCIES} \
    && cd /tmp \
    && git clone https://github.com/ntop/n2n.git n2n \
    && cd n2n \
    && git fetch --all \
    && git checkout 3.0-stable \
    && make supernode \
    && cp supernode /usr/bin/supernode \
    && apk del ${BUILD_DEPENDENCIES} \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/*

CMD /usr/bin/supernode ${ARGUMENTS}
