FROM openjdk:17-jdk as builder

WORKDIR /app/msvc-account

COPY ./pom.xml /app
COPY ./msvc-account/.mvn ./.mvn
COPY ./msvc-account/mvnw .
COPY ./msvc-account/pom.xml .

RUN ./mvnw dependency:go-offline

COPY ./msvc-account/src ./src

RUN ./mvnw clean package -DskipTests

FROM openjdk:17-jdk

WORKDIR /app
RUN mkdir ./logs
COPY --from=builder /app/msvc-account/target/msvc-account-0.0.1-SNAPSHOT.jar .
EXPOSE 8001

CMD ["java", "-jar", "msvc-account-0.0.1-SNAPSHOT.jar"]