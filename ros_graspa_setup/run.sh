#!/usr/bin/env bash

# Expose the X server on the host.
# This only works if the user is root though!

sudo xhost +local:root
# --rm: Make the container ephemeral (delete on exit).
# -it: Interactive TTY.
# --gpus all: Expose all GPUs to the container.
docker run \
  --rm \
  -it \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY=$DISPLAY \
  -e QT_X11_NO_MITSHM=1 \
  hsp-panda/ros_graspa_setup:melodic

sudo xhost -local:root
