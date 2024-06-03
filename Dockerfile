# Use the official Flutter image
FROM cirrusci/flutter:latest

# Create a new user and switch to it
RUN adduser --disabled-password --gecos '' appuser

# Change the ownership of the Flutter SDK to the new user
RUN chown -R appuser:appuser /sdks/flutter

# Set the working directory
WORKDIR /app

# Copy the project files into the container
COPY . /app

RUN chown -R appuser:appuser /app

# Switch to the new user
USER appuser

RUN flutter upgrade
RUN flutter clean

# Get Flutter dependencies
RUN flutter pub get

# Run build_runner to generate necessary files
RUN flutter pub run build_runner build --delete-conflicting-outputs

# Build the Flutter app
RUN flutter build apk --release
