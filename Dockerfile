# Stage 1: Build the application using a full JDK and Maven
FROM public.ecr.aws/docker/library/maven:3.9.11-amazoncorretto-17 AS builder

# Set the working directory inside the container for the build stage
WORKDIR /app
COPY pom.xml .

# Download dependencies first to leverage Docker caching (if pom.xml doesn't change)
RUN mvn -B verify -DskipTests
COPY src ./src

# Run the Maven command to compile, test, and package the application
RUN mvn -B clean install -DskipTests

# Stage 2: Create the final, minimal runtime image
# Use a JRE image (smaller than JDK) for running the application
FROM public.ecr.aws/amazoncorretto/amazoncorretto:17 AS final

# Set the working directory for the final stage
WORKDIR /app

# Copy the built JAR file from the 'builder' stage into the 'final' stage
# This resolves the 'lstat' error because the JAR file is created internally
COPY --from=builder /app/target/ProductAppAWS-0.0.1-SNAPSHOT.jar /app/ProductAppAWS-0.0.1-SNAPSHOT.jar

# Expose the application's port (default for Spring Boot)
EXPOSE 8080

# Define the command to run the application when the container starts
ENTRYPOINT ["java", "-jar", "/app/ProductAppAWS-0.0.1-SNAPSHOT.jar"]
