FROM hyperledger/fabric-ca:1.5 as cert-auth-builder
EXPOSE 7054

ENTRYPOINT ["fabric-ca-server", "start", "-b", "admin:adminpw"]

FROM hyperledger/fabric-ca:1.5

COPY --from=cert-auth-builder /etc/hyperledger/fabric-ca-server /tmp/data/fabric-ca-server
COPY --from=cert-auth-builder /root /tmp/data/root
RUN mkdir -p /app/data

COPY data.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/data.sh

CMD ["/usr/local/bin/data.sh"]
