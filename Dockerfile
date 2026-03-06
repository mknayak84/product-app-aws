
# -------- Stage 1: Build the JAR --------
FROM public.ecr.aws/docker/library/maven:3.9.9-eclipse-temurin-17 AS builder
WORKDIR /workspace

# Copy pom.xml first (to use Docker caching)
COPY pom.xml .
RUN mvn -B -q -DskipTests dependency:go-offline

# Copy application source
COPY src ./src

# Build JAR
RUN mvn -B -DskipTests package

# -------- Stage 2: Run the Application --------
FROM public.ecr.aws/docker/library/openjdk:17
WORKDIR /app

# Copy the built JAR from the builder stage
COPY --from=builder /workspace/target/*SNAPSHOT.jar app.jar

# Expose your Spring Boot port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
