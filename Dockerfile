FROM hyperledger/fabric-ca:1.5

WORKDIR /app

COPY /etc/hyperledger/fabric-ca-server/ /tmp/data/fabric-ca-server/
COPY /root/ /tmp/data/fabric-ca-client/

RUN mkdir -p /app/data

COPY data.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/data.sh

VOLUME ["/app/data"]
CMD ["/usr/local/bin/data.sh"]