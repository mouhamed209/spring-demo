This README explains how to build and run the Spring Boot app using Docker on Windows (cmd.exe).

Prerequisites
- Docker (Docker Desktop) installed and running
- Maven installed locally if you want to build outside of Docker (optional)

Quick build & run (recommended, uses multi-stage Dockerfile):

1) From project root (where the Dockerfile and pom.xml live):

   mvn -DskipTests package
   docker build -t test-app:latest .
   docker run --rm -p 8080:8080 test-app:latest

Alternative: build and run with Docker only (Docker will run Maven in the build stage):

   docker build -t test-app:latest .
   docker run --rm -p 8080:8080 test-app:latest

Run the jar locally without Docker:

   mvn -DskipTests package
   java -jar target\*.jar

Notes
- The Dockerfile is a multi-stage image: it builds the fat JAR using Maven (first stage) and runs it on a smaller JRE image (second stage).
- The Dockerfile uses Eclipse Temurin 21 images; the project declares Java 21 in pom.xml. Adjust if you target a different Java version.
- If you want the image to run on a specific port, change the EXPOSE and docker run -p mapping accordingly.
