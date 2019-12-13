FROM alpine:edge

ENV VERSION 1.0.0rc6
ENV TZ "Etc/GMT"
ENV MAILPILE_GNUPG/GA "/usr/bin/gpg-agent"
ENV MAILPILE_GNUPG/DM "/usr/bin/dirmngr"

# Install requirements
RUN apk update && apk upgrade
RUN apk add --update-cache \
        git \
        tor \
        zlib \
        gnupg \
        gnupg1 \
        py2-pip \
        openssl \
        py-jinja2 \
        py-libxml2 \
        py-libxslt \
        py-lxml \
        py-pbr \
        py-pillow \
        py-cffi \
        py-cryptography \
        ca-certificates
        
# Mailpile read timezone from server, so in docker-compose you can change TZ
RUN apk add --no-cache tzdata

RUN ln -sf "/usr/share/zoneinfo/$TZ" /etc/localtime && \
    echo "$TZ" > /etc/timezone && date

# Get Mailpile from github
RUN git clone https://github.com/mailpile/Mailpile.git

WORKDIR /Mailpile

# Install missing requirements
RUN pip install -r requirements.txt

# Initial Mailpile setup
RUN ./mp setup

CMD ./mp --www=0.0.0.0:33411 --wait
EXPOSE 33411

VOLUME /root/.local/share/Mailpile
VOLUME /root/.gnupg
