#!/bin/bash
set -e

# setup ros environment
if [ -f "/catkin_ws/devel/setup.bash" ]; then
    source /catkin_ws/devel/setup.bash
else
    source /opt/ros/$ROS_DISTRO/setup.bash
fi

exec "$@"