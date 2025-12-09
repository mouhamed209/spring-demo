# المرحلة الأولى: البناء
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /workspace


COPY pom.xml .
COPY src ./src


RUN mvn clean package -DskipTests

# المرحلة الثانية: التشغيل
FROM eclipse-temurin:21-jre
WORKDIR /app

# نسخ ملف الـ JAR الناتج باسم ثابت
COPY --from=build /workspace/target/*.jar app.jar

# فتح المنفذ
EXPOSE 8080

# تشغيل التطبيق
ENTRYPOINT ["java", "-jar", "app.jar"]
