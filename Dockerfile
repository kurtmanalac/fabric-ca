FROM hyperledger/fabric-ca:1.5.5

RUN mkdir -p /app/data/fabric-ca
RUN mkdir -p /app/data/fabric-ca-server
RUN mkdir -p /app/data/fabric-ca-client

ENV FABRIC_CA_HOME=/app/data/fabric-ca
ENV FABRIC_CA_SERVER_HOME=/app/data/fabric-ca-server
ENV FABRIC_CA_CLIENT_HOME=/app/data/fabric-ca-client

USER root
RUN apk update && apk add nodejs npm

COPY node-api /app/data/
RUN chmod +x /app/data/node-api
WORKDIR /app/data

CMD ["sh", "-c", "fabric-ca-server start -b admin:adminpw", "&&", "node", "node-api/app.js"]


# CMD ["data.sh"]
