# API + panel: el backend sirve el build de React en la misma URL.
# El panel se clona desde su repositorio activo para no duplicar código.

FROM node:24-alpine AS web
RUN apk add --no-cache git
RUN git clone --depth 1 https://github.com/jorgeCisternasDev/syncpass-web.git /web
WORKDIR /web
RUN npm ci
ARG VITE_API_URL=/api
ENV VITE_API_URL=${VITE_API_URL}
RUN npm run build

FROM eclipse-temurin:21-jdk AS api
WORKDIR /app
COPY . .
COPY --from=web /web/dist ./src/main/resources/static
RUN sed -i 's/\r$//' gradlew && chmod +x gradlew && ./gradlew bootJar --no-daemon -x test

FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=api /app/build/libs/*.jar app.jar
RUN groupadd --system app && useradd --system --gid app app
USER app
ENV JAVA_TOOL_OPTIONS="-XX:MaxRAMPercentage=75"
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
