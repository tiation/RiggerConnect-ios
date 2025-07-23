# iOS Build Environment (macOS required for actual iOS builds)
# This Dockerfile is for documentation and script execution only
# Actual iOS builds require macOS with Xcode installed

FROM ubuntu:22.04

# Install basic dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    zip \
    unzip \
    python3 \
    python3-pip \
    ruby \
    ruby-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Fastlane
RUN gem install fastlane

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Note: This container is used for:
# 1. Running documentation builds
# 2. Code analysis tools
# 3. Script execution
# 4. CI/CD orchestration

# Actual iOS builds must run on macOS with Xcode
CMD ["echo", "iOS builds require macOS with Xcode. This container is for tooling only."]
