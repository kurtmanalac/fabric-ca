FROM hyperledger/fabric-ca:1.5.5

RUN mkdir -p /app/data/fabric-ca
RUN mkdir -p /app/data/fabric-ca-server
RUN mkdir -p /app/data/fabric-ca-client

ENV FABRIC_CA_HOME=/app/data/fabric-ca
ENV FABRIC_CA_SERVER_HOME=/app/data/fabric-ca-server
ENV FABRIC_CA_CLIENT_HOME=/app/data/fabric-ca-client

USER root
RUN apk update && apk add nodejs npm curl jq unzip

COPY node-api /app/node-api
RUN chmod +x /app/node-api
RUN chmod +x /app/node-api/peer-enroll.sh
COPY server-startup.sh /app/server-startup.sh
RUN chmod +x /app/server-startup.sh
COPY admin-init.sh /app/admin-init.sh
RUN chmod +x /app/admin-init.sh
WORKDIR /app

CMD ["/app/server-startup.sh"]
