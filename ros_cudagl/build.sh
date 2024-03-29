# ====================================
# Build command.
# Change the ros distro and starting image for the recipe if needed
# ====================================

docker build \
    --build-arg from=nvidia/cudagl:10.1-devel-ubuntu18.04 \
    --build-arg ros_distro=melodic \
    --rm \
    --pull \
    -t hsp-panda/ros_cudagl:latest .
