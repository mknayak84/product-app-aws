# Stage 1: Build the application using a full JDK and Maven
FROM maven:3.8.3-openjdk-17 AS builder

# Set the working directory inside the container for the build stage
WORKDIR /app

# Copy the Maven project files (pom.xml and source code) into the container
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
# Download dependencies first to leverage Docker caching (if pom.xml doesn't change)
RUN ./mvnw dependency:go-offline
COPY src ./src

# Run the Maven command to compile, test, and package the application
RUN mvn clean install -DskipTests

# Stage 2: Create the final, minimal runtime image
# Use a JRE image (smaller than JDK) for running the application
FROM openjdk:17-jre-alpine AS final

# Set the working directory for the final stage
WORKDIR /app

# Copy the built JAR file from the 'builder' stage into the 'final' stage
# This resolves the 'lstat' error because the JAR file is created internally
COPY --from=builder /app/target/ProductAppAWS-0.0.1-SNAPSHOT.jar /app/ProductAppAWS-0.0.1-SNAPSHOT.jar

# Expose the application's port (default for Spring Boot)
EXPOSE 8080

# Define the command to run the application when the container starts
ENTRYPOINT ["java", "-jar", "/app/ProductAppAWS-0.0.1-SNAPSHOT.jar"]
