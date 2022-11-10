# ====================================
# Run command. If no argument is given, a ROS master will be created as well as
# the ROS RealSense node.
# ====================================

if [ "$#" -gt 1 ]
then
    echo "Illegal number of parameters. Usage: run.sh [ROS_MASTER_HOST]."
    echo "Example: run.sh 'localhost'"
    exit 1
fi

RESOLUTION_HEIGHT=480
RESOLUTION_WIDTH=640
FPS=15

if [ "$#" -lt 1 ]
then
  # ====================================
  # Spawn a master node
  # ====================================
  docker run --rm \
             --net=host \
             --privileged \
             --volume=/dev:/dev \
             -it ghcr.io/hsp-panda/ros_realsense:latest \
             /bin/bash \
             -i -c 'roslaunch realsense2_camera rs_rgbd.launch\
                   enable_pointcloud:=true align_depth:=false\
                   depth_registered_processing:=true\
                   align_depth:=true\
                   filters:=hole_filling\
                   depth_width:='"${RESOLUTION_WIDTH}"'\
                   depth_height:='"${RESOLUTION_HEIGHT}"'\
                   depth_fps:='"${FPS}"'\
                   color_width:='"${RESOLUTION_WIDTH}"'\
                   color_height:='"${RESOLUTION_HEIGHT}"'\
                   color_fps:='"${FPS}"''
else
  # ====================================
  # Run command with a different ROS_MASTER_URI
  # ====================================
  TARGET_MASTER_URI=${1}
  docker run --rm \
             --net=host \
             --privileged \
             --volume=/dev:/dev \
             -it ghcr.io/hsp-panda/ros_realsense:latest \
             /bin/bash \
             -i -c 'rossetmaster '"${TARGET_MASTER_URI}"'; roslaunch realsense2_camera rs_rgbd.launch\
                                                           enable_pointcloud:=true align_depth:=false\
                                                           depth_registered_processing:=true\
                                                           align_depth:=true\
                                                           filters:=hole_filling\
                                                           depth_width:='"${RESOLUTION_WIDTH}"'\
                                                           depth_height:='"${RESOLUTION_HEIGHT}"'\
                                                           depth_fps:='"${FPS}"'\
                                                           color_width:='"${RESOLUTION_WIDTH}"'\
                                                           color_height:='"${RESOLUTION_HEIGHT}"'\
                                                           color_fps:='"${FPS}"''
fi
