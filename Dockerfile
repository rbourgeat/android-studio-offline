FROM    ubuntu:22.04

RUN     apt-get update
# RUN   apt update

# Install X11
RUN     apt install -y x11-apps sudo

# Install prerequisites
RUN     apt-get install -y openjdk-11-jdk lib32z1 libncurses6 libbz2-1.0 libstdc++6
# RUN   apt install -y openjdk-11-jdk lib32z1 libncurses6 libbz2-1.0 libstdc++6

# Install other useful tools
RUN     apt install -y git vim

RUN     groupadd -g 1000 developer
RUN     useradd -d /home/developer -s /bin/bash -m developer -u 1000 -g 1000

# Download specific Android Studio
COPY    files/android-studio-2022.1.1.21-linux.tar.gz .
RUN     tar -xvf android-studio-2022.1.1.21-linux.tar.gz
RUN     rm android-studio-2022.1.1.21-linux.tar.gz
RUN     mv android-studio /opt

# Download Android Studio Sdk (Android 13.0, API 33, etc...)
RUN     mkdir -p /home/developer/Android
WORKDIR /home/developer/Android
COPY    files/Sdk.tar .
RUN     tar -xvf Sdk.tar
RUN     rm Sdk.tar

RUN     groupadd kvm

USER    developer
ENV     HOME /home/developer
ENV     ANDROID_EMULATOR_USE_SYSTEM_LIBS=1

ENTRYPOINT [ "/opt/android-studio/bin/studio.sh" ]