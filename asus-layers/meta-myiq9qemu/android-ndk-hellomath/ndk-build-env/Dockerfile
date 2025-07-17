# Docker file of ndk-builder
# To build:
# docker image build --build-arg userid=$(id -u) --build-arg groupid=$(id -g) --build-arg username=$(id -un) -t ndk-builder .

# Use a recent Ubuntu LTS as the base image
FROM ubuntu:22.04
ARG userid
ARG groupid
ARG username
ARG password=xxx

# Arguments for tool versions, allows for easy updates
ARG NDK_VERSION="28.2.13676358"
ARG BUILD_TOOLS_VERSION="34.0.0"
ARG CMDLINE_TOOLS_VERSION="11076708"
ARG BAZEL_VERSION="8.3.1"

# Set environment variables to avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Set up Android SDK and NDK environment variables
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV ANDROID_NDK_HOME=${ANDROID_SDK_ROOT}/ndk/${NDK_VERSION}
ENV PATH="${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools:${ANDROID_SDK_ROOT}/ndk/${NDK_VERSION}"

# Install basic dependencies and Java
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    git \
    wget \
    unzip \
    zip \
    openjdk-17-jdk \
    # Clean up APT cache to reduce image size
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Download and install Android SDK command-line tools
RUN wget "https://dl.google.com/android/repository/commandlinetools-linux-${CMDLINE_TOOLS_VERSION}_latest.zip" -O /tmp/cmdline-tools.zip && \
    mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    unzip /tmp/cmdline-tools.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools && \
    mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest && \
    rm /tmp/cmdline-tools.zip

# Accept SDK licenses and install NDK and other required packages
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" \
               "build-tools;${BUILD_TOOLS_VERSION}" \
               "ndk;${NDK_VERSION}" && \
    # Remove the SDK manager to save space as it's large and not needed at runtime
    rm -rf ${ANDROID_SDK_ROOT}/.knownPackages

# Download and install Bazel
RUN wget https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh -O /tmp/bazel-installer.sh && \
    chmod +x /tmp/bazel-installer.sh && \
    /tmp/bazel-installer.sh && \
    rm /tmp/bazel-installer.sh


RUN groupadd -g $groupid $username \
 && useradd -m -u $userid -g $groupid $username \
 && echo $username >/root/username 

RUN echo "${username}:${password}" | chpasswd

# && echo "export USER="$username >>/home/$username/.gitconfig

# You can copy your gitconfig file by unmark these lines.
#COPY gitconfig /home/$username/.gitconfig
#RUN chown $userid:$groupid /home/$username/.gitconfig

ENV HOME=/home/$username
ENV USER=$username


# Set the working directory for the container
WORKDIR /src

# Default command to run when container starts
CMD ["bash"]
