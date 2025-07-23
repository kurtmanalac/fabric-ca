FROM hyperledger/fabric-ca:1.5.5

RUN mkdir -p /app/data/fabric-ca
RUN mkdir -p /app/data/fabric-ca-server
RUN mkdir -p /app/data/fabric-ca-client

ENV FABRIC_CA_HOME=/app/data/fabric-ca
ENV FABRIC_CA_SERVER_HOME=/app/data/fabric-ca-server
ENV FABRIC_CA_CLIENT_HOME=/app/data/fabric-ca-client

WORKDIR /app/data
# COPY data.sh /usr/local/bin/
# RUN chmod +x /usr/local/bin/data.sh

# CMD ["/usr/local/bin/data.sh"]
# Install a simple HTTP server
USER root
RUN apk update && apk add python3
EXPOSE 8000

# Start both your original service and HTTP server
EXPOSE 7054
CMD ["python3", "-m", "http.server", "8000"]
