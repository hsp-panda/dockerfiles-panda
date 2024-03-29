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
    catkin config --extend /opt/ros/$ROS_DISTRO -DCATKIN_ENABLE_TESTING=False -DCMAKE_BUILD_TYPE=Release && \
    catkin build

RUN echo "source /catkin_ws/devel/setup.bash" >> /root/.bashrc

# ======================================
# Install RealSense ROS packages
# ======================================

ENV LIBREALSENSE_TAG v2.45.0
ENV REALSENSEROS_TAG 2.3.0

RUN apt -q -qq update && \
  apt install -y libssl-dev libusb-1.0-0-dev pkg-config libgtk-3-dev && \
  git clone https://github.com/IntelRealSense/librealsense.git && \
  cd librealsense && git checkout ${LIBREALSENSE_TAG} && \
  mkdir build && cd build && \
  cmake .. -DBUILD_EXAMPLES=false -DBUILD_GRAPHICAL_EXAMPLES=false -DBUILD_WITH_OPENMP=false -DFORCE_RSUSB_BACKEND=true && \
  make -j8 && make install

RUN mkdir -p /etc/udev/rules.d && cp librealsense/config/99-realsense-libusb.rules /etc/udev/rules.d/

WORKDIR /catkin_ws/src
RUN git clone https://github.com/IntelRealSense/realsense-ros.git && \
    git clone https://github.com/pal-robotics/ddynamic_reconfigure.git
RUN cd realsense-ros && git checkout ${REALSENSEROS_TAG}
RUN apt-get update && \
    apt-get install ros-melodic-rgbd-launch && \
    rosdep install --from-paths realsense-ros ddynamic_reconfigure --ignore-src -r -y --skip-keys librealsense2 && \
    rm -rf /var/lib/apt/lists/* && \
    catkin build

# ======================================
# Clone and build robot-specific stuff
# ======================================

WORKDIR /

# A specific version of libfranka might be necessary depending on robot firmware version
ENV LIBFRANKA_TAG 0.8.0

RUN apt-get update && \
    apt-get install -y \
    libpoco-dev libeigen3-dev && \
    rm -rf /var/lib/apt/lists/*

RUN git clone --recursive https://github.com/frankaemika/libfranka && \
    cd libfranka && \
    git checkout ${LIBFRANKA_TAG} && git submodule update && \
    mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make install -j4

RUN rm -rf libfranka

WORKDIR /catkin_ws/src

RUN git clone https://github.com/hsp-panda/franka_ros.git
RUN git clone https://github.com/hsp-panda/panda_moveit_config.git
RUN apt-get update && \
    rosdep install --from-paths franka_ros panda_moveit_config --ignore-src -r -y --skip-keys libfranka && \
    rm -rf /var/lib/apt/lists/*
RUN catkin build

# ======================================
# Clone and build panda_grasp_server
# ======================================

WORKDIR /catkin_ws/src
RUN git clone https://github.com/hsp-panda/panda_ros_common.git && \
    git clone https://github.com/hsp-panda/panda_grasp_server.git
RUN apt-get update && \
    rosdep install --from-paths panda_ros_common panda_grasp_server --ignore-src -r -y && \
    rm -rf /var/lib/apt/lists/*
RUN catkin build

# ======================================
# Cleanup
# ======================================

RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /librealsense

# ======================================
# Setup an additional entrypoint script
# ======================================

COPY entrypoint.sh /usr/sbin/entrypoint.sh
RUN chmod 777 /usr/sbin/entrypoint.sh
ENTRYPOINT ["/usr/sbin/entrypoint.sh"]
CMD ["bash"]
