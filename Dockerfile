FROM hyperledger/fabric-ca:1.5.5

RUN mkdir -p /app/data/fabric-ca
RUN mkdir -p /app/data/fabric-ca-server
RUN mkdir -p /app/data/fabric-ca-client

ENV FABRIC_CA_HOME=/app/data/fabric-ca
ENV FABRIC_CA_SERVER_HOME=/app/data/fabric-ca-server
ENV FABRIC_CA_CLIENT_HOME=/app/data/fabric-ca-client

USER root
RUN apk update && apk add nodejs npm

COPY node-api /app/data/node-api
RUN chmod +x /app/data/node-api
COPY server-startup.sh /app/data/server-startup.sh
RUN chmod +x /app/data/server-startup.sh
COPY admin-enroll.sh /app/data/admin-enroll.sh
RUN chmod +x /app/data/admin-enroll.sh
WORKDIR /app/data

CMD ["/app/data/server-startup.sh"]
