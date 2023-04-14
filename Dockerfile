FROM node:18.12.1

RUN     apt-get update
# RUN   apt update

# Download specific Android Studio
COPY    files/android-studio-2022.1.1.21-linux.tar.gz .
RUN     tar -xvf android-studio-2022.1.1.21-linux.tar.gz
RUN     rm android-studio-2022.1.1.21-linux.tar.gz
RUN     mv android-studio /opt

# Download Android Studio Sdk (Android 13.0, API 33, etc...)
RUN     mkdir -p /home/developer/Android
COPY    files/Sdk.tar /home/developer/Android
RUN     tar -xvf /home/developer/Android/Sdk.tar
RUN     rm /home/developer/Android/Sdk.tar

# Install X11
RUN     apt install -y x11-apps sudo

# Install prerequisites
RUN     apt-get install -y openjdk-11-jdk lib32z1 libncurses6 libbz2-1.0 libstdc++6
# RUN   apt install -y openjdk-11-jdk lib32z1 libncurses6 libbz2-1.0 libstdc++6

# Install other useful tools
RUN     apt install -y git vim
# RUN npm install --global yarn@8.19.2

# Set up permissions for X11 access.
RUN     export uid=42 gid=42 && \
        mkdir -p /home/developer && \
        echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
        echo "developer:x:${uid}:" >> /etc/group && \
        echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
        chmod 0440 /etc/sudoers.d/developer && \
        chown ${uid}:${gid} -R /home/developer

USER    developer
ENV     HOME /home/developer

ENTRYPOINT [ "/opt/android-studio/bin/studio.sh" ]