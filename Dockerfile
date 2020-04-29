FROM combustml/mleap-serving:0.16.0-SNAPSHOT

# Override default server port if needed
ENV SERVER_PORT=8080
EXPOSE 8080

# Copy models
COPY models/*.zip models/

# Copy application.properties
COPY config/application.properties ./application.properties

# Copy startup configs
COPY config/startup/*.json ./config/startup/