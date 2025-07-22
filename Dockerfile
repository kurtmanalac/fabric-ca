FROM hyperledger/fabric-ca:1.5 as fabric-ca

FROM ubuntu:20.04

WORKDIR /app

COPY --from=fabric-ca . /tmp/data/fabric-ca

RUN mkdir -p /app/data

COPY data.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/data.sh

CMD ["/usr/local/bin/data.sh"]
