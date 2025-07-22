FROM hyperledger/fabric-ca:1.5 as cert-auth builder

FROM hyperledger/fabric-ca:1.5

WORKDIR /app

COPY --from=cert-auth /etc/hyperledger/fabric-ca-server /tmp/data/fabric-ca-server
COPY --from=cert-auth /root /tmp/data/root
RUN mkdir -p /app/data

COPY data.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/data.sh

CMD ["/usr/local/bin/data.sh"]

EXPOSE 7054

# Start the CA server
# ENTRYPOINT ["fabric-ca-server", "start", "-b", "admin:adminpw"]
