FROM openjdk:8-jre
WORKDIR /app
# Copy the built app from the app-build stage
COPY ./target /app/target
COPY entrypoint.sh .

EXPOSE 8080

RUN chmod +x ./entrypoint.sh

ENTRYPOINT [ "./entrypoint.sh" ]