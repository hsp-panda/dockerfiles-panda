#!/usr/bin/env bash

# ==============================
# EDIT THESE PARAMETERS BEFORE RUNNING THE SCRIPT

ROBOT_IP=172.16.0.2
GRASP_SERVER_CONFIG=grasp_server_config.yaml
# Set to use custom table height, otherwise default for config will be used
TABLE_HEIGHT=""

# ==============================
# DO NOT EDIT THESE PARAMETERS BEFORE RUNNING THE SCRIPT

# Create shared directory if doesn't exist yet
SHARED_DIR_PATH=$PWD/shared
MOUNT_POINT=/shared
if [[ -d "$SHARED_DIR_PATH" ]]
then
  echo "Directory $SHARED_DIR_PATH already exists"
else
  echo "Creating directory $SHARED_DIR_PATH "
fi

echo "Mounting existing directory $SHARED_DIR_PATH in container path $MOUNT_POINT"

# Expose the X server on the host.
xhost +local:root
# --rm: Make the container ephemeral (delete on exit).
# -it: Interactive TTY.
# --gpus all: Expose all GPUs to the container.
docker run \
  -it \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /dev:/dev \
  -v $SHARED_DIR_PATH:$MOUNT_POINT \
  -e DISPLAY=$DISPLAY \
  -e QT_X11_NO_MITSHM=1 \
  --network=host \
  --privileged \
  --name robot_control_container \
  ghcr.io/hsp-panda/ros_panda_setup_graspa:latest \
  /bin/bash -i -c 'roslaunch panda_grasp_server GRASPA_pipeline.launch \
                                robot_ip:='"${ROBOT_IP}"' \
                                table_height:='"${TABLE_HEIGHT}"' \
                                grasp_server_config:='"${GRASP_SERVER_CONFIG}"''

xhost -local:root

echo "Changing permissions for $SHARED_DIR_PATH "
sudo chown -hR `id -u`:`id -g` $SHARED_DIR_PATH
