# ====================================
# Build command.
# Change the ros distro and starting image for the recipe if needed
# ====================================

docker build \
    --build-arg ros_distro=melodic \
    --rm \
    --pull \
    -t ros/realsense:melodic .
