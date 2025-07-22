FROM hyperledger/fabric-ca:1.5 as fabric-ca

WORKDIR /app

COPY --from=fabric-ca /etc/hyperledger/fabric-ca-server /tmp/data/fabric-ca

RUN mkdir -p /app/data

COPY data.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/data.sh

CMD ["/usr/local/bin/data.sh"]

EXPOSE 7054

# Start the CA server
# ENTRYPOINT ["fabric-ca-server", "start", "-b", "admin:adminpw"]
