FROM ubuntu:18.04
MAINTAINER Daniel Nicolas Gisolfi

ENV DEBIAN_FRONTEND=noninteractive
ENV VERSION=02
ENV HOST_IP=10.11.17.38

RUN apt-get update -y \
    && apt-get install -y \
        build-essential \
        openssh-server \
        python3-pip \
        zlib1g-dev \ 
        tzdata \
        wget \
        gcc \
        && pip3 install --upgrade pip

EXPOSE 22
EXPOSE 2222

# Set the TimeZone 
RUN cp /usr/share/zoneinfo/America/New_York /etc/localtime \
    && dpkg-reconfigure tzdata

WORKDIR /

# Install openssl version 1.0.2, newer versions cause issues
RUN wget https://openssl.org/source/openssl-1.0.2.tar.gz \
    && tar -xf openssl-1.0.2.tar.gz \
    && cd openssl-1.0.2 \
    && make clean \
    && ./config zlib \
    && make \
    && make install

WORKDIR /usr/local/source/openssh/openssh-22
# Install openssh into the directory
RUN wget ftp://ftp4.usa.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.2p1.tar.gz \
    && tar -xf openssh-7.2p1.tar.gz \
    && mv openssh-7.2p1 openssh-7.2p1-22

# replace config files with custom ones
WORKDIR /usr/local/source/openssh/openssh-22/openssh-7.2p1-22
# rename original files
RUN mv auth-passwd.c auth-passwd.c.orig \
    && mv sshd.c sshd.c.orig \
    && mv auth2-pubkey.c auth2-pubkey.c.orig

COPY ./src/sshd.c sshd.c
COPY ./src/client.c client.c
COPY ./src/sshd_config-22 sshd_config-22
COPY ./src/auth-passwd.c auth-passwd.c

# Get Custom files from eric wedaa's repository
RUN wget https://raw.githubusercontent.com/wedaa/LongTail-Openssh-honeypot-v2/master/auth2-pubkey.c \
    && cp sshd_config-22 /usr/local/etc

# Now confgure the ssh server with new configs
RUN ./configure \
    && make \
    && make install \
    && cp sshd /usr/local/sbin/sshd-22 \
    && chmod a+rx sshd /usr/local/sbin/sshd-22

WORKDIR /usr/local/source/openssh/openssh-2222

# Install openssh into the directory
RUN wget ftp://ftp4.usa.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.2p1.tar.gz \
    && tar -xf openssh-7.2p1.tar.gz \
    && mv openssh-7.2p1 openssh-7.2p1-2222

# replace config files with custom ones
WORKDIR /usr/local/source/openssh/openssh-2222/openssh-7.2p1-2222
# rename original files
RUN mv auth-passwd.c auth-passwd.c.orig \
    && mv sshd.c sshd.c.orig \
    && mv auth2-pubkey.c auth2-pubkey.c.orig

COPY ./src/sshd.c sshd.c
COPY ./src/client.c client.c
COPY ./src/sshd_config-2222 sshd_config-2222
COPY ./src/auth-passwd.c auth-passwd.c

# Get Custom files from eric wedaa's repository
RUN wget https://raw.githubusercontent.com/wedaa/LongTail-Openssh-honeypot-v2/master/auth2-pubkey.c \
    && cp sshd_config-2222 /usr/local/etc

# Now confgure the ssh server with new configs
RUN ./configure \
    && make \
    && make install \
    && cp sshd /usr/local/sbin/sshd-2222 \
    && chmod a+rx sshd /usr/local/sbin/sshd-2222

# Setup TCP Server
WORKDIR /TcpServer
COPY ./TcpServer .

RUN pip install -r requirements.txt \
    && chmod +x init.sh

ENTRYPOINT [ "/bin/bash" ]
CMD ["./init.sh"]