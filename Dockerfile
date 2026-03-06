# Use the official OpenJDK 17 image from Docker Hub
FROM public.ecr.aws/docker/library/openjdk:17

# Set working directory inside the container
WORKDIR /app

# Copy the compiled Java application JAR file into the container
COPY target/product-app-aws-0.0.1-SNAPSHOT.jar app.jar

# Expose the port the Spring Boot application will run on
EXPOSE 8181

# Command to run the application
CMD ["java", "-jar", "app.jar"]
