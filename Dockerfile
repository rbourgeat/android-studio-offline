FROM ubuntu:22.04

# Install dependencies
RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install -y \
        build-essential git neovim wget unzip sudo \
        libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386 \
        libxrender1 libxtst6 libxi6 libfreetype6 libxft2 xz-utils vim\
        qemu qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils libnotify4 libglu1 libqt5widgets5 openjdk-8-jdk openjdk-11-jdk xvfb \
        && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# Create User
ARG USER=rbourgeat
RUN groupadd -g 1000 -r $USER
RUN useradd -u 1000 -g 1000 --create-home -r $USER
RUN adduser $USER libvirt
RUN adduser $USER kvm
# Remove password
RUN echo "$USER:$USER" | chpasswd
RUN echo "${USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-$USER
RUN usermod -aG sudo $USER
RUN usermod -aG plugdev $USER

VOLUME /androidstudio-data
RUN chown $USER:$USER /androidstudio-data

COPY dockerfiles/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY dockerfiles/ndkTests.sh /usr/local/bin/ndkTests.sh
RUN chmod +x /usr/local/bin/*
COPY dockerfiles/51-android.rules /etc/udev/rules.d/51-android.rules

USER $USER
WORKDIR /home/$USER

#Install Flutter
ARG FLUTTER_URL=https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_1.22.2-stable.tar.xz
ARG FLUTTER_VERSION=1.22.2
RUN wget "$FLUTTER_URL" -O flutter.tar.xz
RUN tar -xvf flutter.tar.xz
RUN rm flutter.tar.xz

ARG ANDROID_STUDIO_VERSION=2022.1.1.21
COPY files/android-studio-2022.1.1.21-linux.tar.gz .
RUN tar -xvf android-studio-2022.1.1.21-linux.tar.gz
RUN rm android-studio-2022.1.1.21-linux.tar.gz
RUN mv android-studio /opt

RUN ln -s /studio-data/profile/AndroidStudio$ANDROID_STUDIO_VERSION .AndroidStudio$ANDROID_STUDIO_VERSION
RUN ln -s /studio-data/Android Android
RUN ln -s /studio-data/profile/android .android
RUN ln -s /studio-data/profile/java .java
RUN ln -s /studio-data/profile/gradle .gradle
ENV ANDROID_EMULATOR_USE_SYSTEM_LIBS=1

WORKDIR /home/$USER

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]