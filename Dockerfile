FROM hyperledger/fabric-ca:1.5 as fabric-ca

FROM ubuntu:20.04

COPY --from=fabric-ca /etc/hyperledger /tmp/data/fabric-ca-server/
COPY --from=fabric-ca /root /tmp/data/fabric-ca-client/

RUN mkdir -p /app/data

COPY data.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/data.sh

CMD ["/usr/local/bin/data.sh"]
CMD ["fabric-ca-server" "start" "-b" "admin:adminpw"]

