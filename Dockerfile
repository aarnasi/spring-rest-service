# Use a base image with OpenJDK and Gradle installed
FROM gradle:7.6-jdk17 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the Gradle project files
COPY /app/build.gradle settings.gradle /app/
COPY /app/src /app/src

# Build the applcation
RUN gradle build --no-daemon

# Use a smaller base image for the final container
FROM openjdk:17

# Set the working directory in the container
WORKDIR /app

# Copy the JAR file from the build stage to the final container
COPY --from=build /app/build/libs/*.jar /app/rest-service-app.jar

EXPOSE 8080

# Specify the command to run the JAR file
ENTRYPOINT ["java", "-jar", "rest-service-app.jar"]