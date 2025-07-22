FROM hyperledger/fabric-ca:1.5
ENTRYPOINT ["fabric-ca-server", "start", "-b", "admin:adminpw"]

COPY /etc/hyperledger/fabric-ca-server /tmp/data/fabric-ca-server
COPY /root /tmp/data/root
RUN mkdir -p /app/data

COPY data.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/data.sh

CMD ["/usr/local/bin/data.sh"]

EXPOSE 7054
