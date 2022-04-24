FROM alpine:latest AS builder
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
RUN apk add --no-cache git bash autoconf automake gcc make musl-dev pkgconfig linux-headers
WORKDIR /opt
RUN git clone https://github.com/ntop/n2n.git -b 3.0-stable
WORKDIR /opt/n2n
RUN ./autogen.sh && ./configure && make && make install

FROM alpine:latest
ENV PARAMETER "-v"
COPY --from=builder /usr/sbin/supernode /usr/bin
COPY --from=builder /usr/sbin/edge /usr/bin
COPY startup.sh /
RUN chomd -R 777 /startup.sh
EXPOSE 7654/udp
EXPOSE 5645/udp

CMD ["/startup.sh"]
