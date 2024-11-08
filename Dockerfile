FROM openjdk:11-jdk-slim AS builder

WORKDIR /app

# Clone the repository from GitHub
RUN apt-get update && apt-get install -y git
RUN git clone --branch ${BRANCH} https://github.com/Nadr0j/RunescapeRealTimePricesCachingClient .

# Build the project
RUN ./gradlew build --no-daemon

# Log the name of the built JAR
RUN echo "Built JAR files:" && ls build/libs/

# Run stage
FROM openjdk:11-jdk-slim

WORKDIR /app

# Copy the built jar from the builder image
COPY --from=builder /app/build/libs/*.jar /app/server.jar

# Expose port 10100
EXPOSE 10100

# Start the server
CMD ["java", "-jar", "/app/server.jar"]
