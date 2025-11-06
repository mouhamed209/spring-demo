# المرحلة الأولى: البناء
FROM maven:3.8.6-openjdk-11 AS build
WORKDIR /workspace
COPY pom.xml .
COPY src ./src
RUN mvn -B -DskipTests package

# المرحلة الثانية: التشغيل
FROM openjdk:11-jre-slim
WORKDIR /app
COPY --from=build /workspace/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
