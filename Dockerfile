# Stage 1: Build the application using a Maven image
FROM public.ecr.aws/docker/library/maven:3.9.11-amazoncorretto-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Stage 2: Create the final runtime image
FROM public.ecr.aws/amazoncorretto/amazoncorretto:17
WORKDIR /app
# Copy the JAR file from the build stage
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
