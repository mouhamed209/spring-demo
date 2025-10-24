# Multi-stage Dockerfile for Java 21 (Eclipse Temurin)
# Build stage: use Maven with Temurin JDK 21 to compile and package the app
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /workspace
# Copy only the files needed for dependency resolution first for better caching
COPY pom.xml mvnw mvnw.cmd ./
# If you have a .mvn folder, copy it too (uncomment next line)
# COPY .mvn .mvn
# Copy source and build
COPY src ./src
COPY pom.xml ./

# Use the Maven in the image to build (skip tests for faster builds; remove -DskipTests to run tests)
RUN mvn -B -DskipTests package

# Runtime stage: smaller image with Temurin JRE 21
FROM eclipse-temurin:21-jre

# Create a non-root user for better security
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser || true
WORKDIR /app

# Copy the built jar from the build stage. Use a glob to pick the Spring Boot jar.
ARG JAR_FILE=target/*.jar
COPY --from=build /workspace/${JAR_FILE} app.jar

# Expose default Spring Boot port
EXPOSE 8080

# Run as non-root user
USER appuser

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
