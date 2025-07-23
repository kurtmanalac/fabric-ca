FROM hyperledger/fabric-ca:1.5.5

RUN mkdir -p /app/data/fabric-ca
RUN mkdir -p /app/data/fabric-ca-server
RUN mkdir -p /app/data/fabric-ca-client

ENV FABRIC_CA_HOME=/app/data/fabric-ca
ENV FABRIC_CA_SERVER_HOME=/app/data/fabric-ca-server
ENV FABRIC_CA_CLIENT_HOME=/app/data/fabric-ca-client

WORKDIR /app/data

# Install a simple HTTP server
USER root
RUN apk update && apk add python3
EXPOSE 8000
EXPOSE 7054

COPY data.sh /app/data/data.sh
RUN chmod +x /app/data/data.sh

# Start both your original service and HTTP server
CMD ["sh", "-c", "fabric-ca-server start -b admin:adminpw]


# CMD ["data.sh"]
