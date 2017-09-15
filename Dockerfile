FROM quay.io/kwiksand/cryptocoin-base:latest

RUN useradd -m monacocoin

ENV DAEMON_RELEASE=0.12.1.5.1
ENV MONACOCOIN_DATA=/home/monacocoin/.monacocoin

USER monacocoin

RUN cd /home/monacocoin && \
    mkdir .ssh && \
    chmod 700 .ssh && \
    ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts && \
    ssh-keyscan -t rsa bitbucket.org >> ~/.ssh/known_hosts && \
    git clone  --branch $DAEMON_RELEASE https://github.com/monacocoin-group/monacocoin.git monacocoind && \
    cd /home/monacocoin/monacocoind && \
    ./autogen.sh && \
    ./configure LDFLAGS="-L/home/monacocoin/db4/lib/" CPPFLAGS="-I/home/monacocoin/db4/include/" && \
    make && \
    strip src/monacoCoind && \
    strip src/monacoCoin-cli && \
    strip src/monacoCoin-tx
    
EXPOSE 24156 24157

#VOLUME ["/home/monacocoin/.monacocoin"]

USER root

COPY docker-entrypoint.sh /entrypoint.sh

RUN chmod 777 /entrypoint.sh && \
    chmod 755 /home/monacocoin/monacocoind/src/{monacoCoind,monacoCoin-cli,monacoCoin-tx} && \
    ln -s /home/monacocoin/monacocoind/src/{monacoCoind,monacoCoin-cli,monacoCoin-tx} /usr/bin/

ENTRYPOINT ["/entrypoint.sh"]

CMD ["monacocoind"]
