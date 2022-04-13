ARG from=ubuntu:bionic
ARG ros_distro=melodic

FROM ${from}

# ======================================
# Docker image maintainer info
# ======================================

LABEL maintainer="fabrizio.bottarel@iit.it"

# ======================================
# Docker image arguments
# ======================================

ARG ros_distro
ARG DEBIAN_FRONTEND=noninteractive

# ======================================
# Set up essentials
# ======================================

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    nano \
    curl \
    gpg \
    dirmngr \
    lsb-release \
    wget \
    unzip \
    locales \
    software-properties-common \
    tree \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    gdb \
    cmake \
    cmake-curses-gui \
    python \
    python-pip \
    && rm -rf /var/lib/apt/lists/*

# ======================================
# Set up locales
# ======================================

RUN sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen && \
    locale-gen &&\
    update-locale LANG="en_US.UTF-8"

# ======================================
# Setup HW Acceleration, glvnd and x11
# ======================================

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libglvnd0 \
    libgl1 \
    libglx0 \
    libegl1 \
    libxext6 \
    libx11-6 \
    glmark2 \
    libgl1-mesa-glx \
    libgl1-mesa-dri &&\
    rm -rf /var/lib/apt/lists/*

# ======================================
# Set up ROS full desktop installation
# ======================================
# From https://github.com/osrf/docker_images/blob/master/ros/melodic/ubuntu/bionic/ros-core/Dockerfile
# ======================================

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    python-rosdep \
    python-rosinstall \
    python-vcstools \
    python-catkin-tools \
    ros-${ros_distro}-jsk-tools \
    && rm -rf /var/lib/apt/lists/*

RUN rosdep init && \
    rosdep update

RUN apt-get update && apt-get install -y \
    ros-${ros_distro}-desktop-full \
    && rm -rf /var/lib/apt/lists/*

ENV ROS_DISTRO ${ros_distro}
# Some QT-Apps/Gazebo don't show controls without this
ENV QT_X11_NO_MITSHM 1

RUN mkdir -p /catkin_ws/src && \
    cd /catkin_ws && \
    catkin config --extend /opt/ros/$ROS_DISTRO && \
    catkin build

RUN echo "source /catkin_ws/devel/setup.bash" >> /root/.bashrc

# ======================================
# Setup an additional entrypoint script
# ======================================

COPY entrypoint.sh /usr/sbin/entrypoint.sh
RUN chmod 777 /usr/sbin/entrypoint.sh
ENTRYPOINT ["/usr/sbin/entrypoint.sh"]
CMD ["roscore"]