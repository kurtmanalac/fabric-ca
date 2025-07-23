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

# Start both your original service and HTTP server
EXPOSE 7054
# CMD ["sh", "-c", "python3", "-m", "http.server", "8000", "&&", "fabric-ca-server", "start", "-b", "admin:adminpw"]
COPY data.sh data.sh
RUN chmod +x data.sh

CMD ["data.sh"]
