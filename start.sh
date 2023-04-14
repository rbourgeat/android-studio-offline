sudo docker build -t android-studio-offline .

sudo docker run -ti --rm \
   -e DISPLAY=$DISPLAY \
   --privileged \
   -v /tmp/.X11-unix:/tmp/.X11-unix \
   android-studio-offline