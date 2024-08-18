# Stage 1: Build and extract the application from the zip file
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy the zip file from the artifact staging directory
COPY ./TestProject.zip /app/TestProject.zip

# Extract the contents of the zip file
RUN apt-get update && apt-get install -y unzip && \
    unzip TestProject.zip -d . && \
    rm TestProject.zip

FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS base
WORKDIR /app

# Copy the extracted files from the build stage
COPY --from=build /app .

# Expose the necessary port (adjust if necessary)
EXPOSE 80

# Set the entry point to run the application
ENTRYPOINT ["dotnet", "TestProject.dll"]

# Keep the container alive for debugging
CMD ["sh", "-c", "dotnet TestProject.dll; tail -f /dev/null"]
