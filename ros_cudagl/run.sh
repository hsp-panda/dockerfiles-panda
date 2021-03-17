# ====================================
# Run command. Verify if the xauth file exists or if a container with the same
# name is already running.
# ====================================

if [ "$#" -lt 2 ]; then
    echo "Illegal number of parameters. Usage: run.sh <username> <container-id> [image-name]"
    echo "Example: run.sh panda-user ros-container"
    exit 1
fi

# ====================================
# Specify some variables that are useful while setting up the container
# ====================================

USERNAME=${1:-"panda-user"}
CONTAINERNAME=${2:-"ros-container"}
IMAGENAME=${3:-"panda/ros:nvidia"}
XSOCK="/tmp/.X11-unix"
XAUTH="/tmp/.$CONTAINERNAME.xauth"
USER_UID=$UID
USER_GID=$UID

echo "Running container $CONTAINERNAME as $USERNAME..."

# ====================================
# Create a Xauth file for each container if it does not already exist
# ====================================

if [ ! -f $XAUTH ]
then
    xauth nlist :0 | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
    chmod a+x $XAUTH
    echo "Created file Xauth file $XAUTH"
fi

# ====================================
# Spin up the container with the specified options (if it doesn't exist already)
#
# This should support both nvidia and intel graphics adapters
# A shared directory will be created in HOME/workspace/docker-shared-workspace/$CONTAINERNAME
#
# Add --network=host and --privileged if connecting to other ROS nodes
# Add --volume=<host-volume>:<mount-point> for sharing the host filesystem
# ====================================

if [ ! "$(docker ps -a | grep $CONTAINERNAME)" ]
then
    TIMESTAMP=`date +"%y_%m_%d-%k_%M_%S"`
    CONTAINERNAME=$CONTAINERNAME-$TIMESTAMP
    mkdir -p $HOME/workspace/docker-shared-workspace/$CONTAINERNAME
    docker run \
        -it \
        --name=$CONTAINERNAME \
        -e DISPLAY=$DISPLAY \
        -e QT_X11_NO_MITSHM=1 \
        -e USER_UID=$USER_UID \
        -e USER_GID=$USER_GID \
        -e USERNAME=$USERNAME \
        -e XAUTHORITY=$XAUTH \
        --volume=$XSOCK:$XSOCK:rw \
        --volume=$XAUTH:$XAUTH:rw \
        --device /dev/dri \
        --gpus=all \
        --volume=$HOME/workspace/docker-shared-workspace/$CONTAINERNAME:/home/$USERNAME/workspace \
        $IMAGENAME \
        bash
else
    docker start $CONTAINERNAME > /dev/null
    docker exec -it -u $USERNAME $CONTAINERNAME bash
fi