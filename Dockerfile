FROM alpine/git AS clone
ARG url
WORKDIR /app
RUN git clone ${url}

FROM openjdk:16-alpine3.13
ARG project
WORKDIR /app
COPY --from=clone /app/${project} /app
RUN ./mvnw dependency:go-offline
CMD ["./mvnw", "spring-boot:run"]
