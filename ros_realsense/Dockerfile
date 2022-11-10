ARG ros_distro=melodic

FROM ros:${ros_distro}

LABEL maintainer="fabrizio.bottarel@iit.it"

ENV ROS_DISTRO melodic
ENV LIBREALSENSE_TAG v2.50.0
ENV REALSENSEROS_TAG ros1-legacy

# Set up wget

RUN apt -q -qq update && \
  DEBIAN_FRONTEND=noninteractive apt install -y \
  software-properties-common \
  wget

# Set up the realsense apt repo

# RUN echo 'deb http://realsense-hw-public.s3.amazonaws.com/Debian/apt-repo xenial main' || tee /etc/apt/sources.list.d/realsense-public.list
# RUN apt-key adv --keyserver keys.gnupg.net --recv-key C8B3A55A6F3EFCDE || apt-key adv --keyserver hkp://keys.gnupg.net:80 --recv-key C8B3A55A6F3EFCDE
# RUN add-apt-repository "deb http://realsense-hw-public.s3.amazonaws.com/Debian/apt-repo xenial main"
# RUN apt-get update -qq
# RUN apt-get install librealsense2-dkms --allow-unauthenticated -y
# RUN apt-get install librealsense2-dev --allow-unauthenticated -y

# Compile and install librealsense from source

RUN apt -q -qq update && \
  apt install -y  git libssl-dev libusb-1.0-0-dev pkg-config libgtk-3-dev && \
  git clone https://github.com/IntelRealSense/librealsense.git && \
  cd librealsense && git checkout ${LIBREALSENSE_TAG} && \
  mkdir build && cd build && \
  cmake .. -DBUILD_EXAMPLES=true -DBUILD_GRAPHICAL_EXAMPLES=false -DBUILD_WITH_OPENMP=true -DFORCE_RSUSB_BACKEND=true && \
  make -j8 && make install

RUN mkdir -p /etc/udev/rules.d && cp librealsense/config/99-realsense-libusb.rules /etc/udev/rules.d/

# Set up the ROS dependencies

RUN apt -q -qq update && \
  DEBIAN_FRONTEND=noninteractive apt install -y --allow-unauthenticated \
  python-rosinstall \
  python-catkin-tools \
  ros-${ROS_DISTRO}-jsk-tools \
  ros-${ROS_DISTRO}-rgbd-launch \
  ros-${ROS_DISTRO}-image-transport-plugins \
  ros-${ROS_DISTRO}-image-transport

RUN rosdep update

# Create a catkin ws, clone and compile

RUN mkdir -p /catkin_ws/src && cd /catkin_ws/src && \
  git clone https://github.com/IntelRealSense/realsense-ros.git && \
  git clone https://github.com/pal-robotics/ddynamic_reconfigure
RUN cd /catkin_ws/src/realsense-ros && git checkout ${REALSENSEROS_TAG}
RUN cd catkin_ws
RUN mv /bin/sh /bin/sh_tmp && ln -s /bin/bash /bin/sh
RUN source /opt/ros/${ROS_DISTRO}/setup.bash; cd catkin_ws; catkin build -DCATKIN_ENABLE_TESTING=False -DCMAKE_BUILD_TYPE=Release

# Set up environment

RUN touch /root/.bashrc && \
  echo "source /catkin_ws/devel/setup.bash" >> /root/.bashrc && \
  echo "rossetip" >> /root/.bashrc && \
  echo "rossetmaster localhost"

# Cleanup

RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /librealsense

# Set entrypoint

COPY ./ros_entrypoint.sh /
ENTRYPOINT ["/ros_entrypoint.sh"]

CMD ["bash"]
