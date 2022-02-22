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

if [ "$#" -lt 1 ]
then
  # ====================================
  # Spawn a master node
  # ====================================
  docker run --rm \
             --net=host \
             --privileged \
             --volume=/dev:/dev \
             -it \
             ros/realsense:melodic \
             /bin/bash \
             -i -c 'roslaunch realsense2_camera rs_rgbd.launch enable_pointcloud:=true align_depth:=false depth_registered_processing:=true align_depth:=true'
else
  # ====================================
  # Run command with a different ROS_MASTER_URI
  # ====================================
  TARGET_MASTER_URI=${1}
  docker run --rm \
             --net=host \
             --privileged \
             --volume=/dev:/dev \
             -it ros/realsense:melodic \
             /bin/bash \
             -i -c 'rossetmaster '"${TARGET_MASTER_URI}"'; roslaunch realsense2_camera rs_rgbd.launch enable_pointcloud:=true align_depth:=false depth_registered_processing:=true align_depth:=true filters:=hole_filling'
fi
