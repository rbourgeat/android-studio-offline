#!/bin/bash

docker build -t android-studio-offline .

docker run -tdi --rm \
   -e DISPLAY=$DISPLAY \
   --privileged \
   -v /tmp/.X11-unix:/tmp/.X11-unix \
   --device=/dev/kvm --group-add kvm \
   -v /home/developer:/home/administrateur \
   android-studio-offline