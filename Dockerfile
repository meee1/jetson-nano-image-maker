FROM ubuntu:20.04 as base

RUN apt update
RUN apt install -y ca-certificates

RUN apt install -y sudo
RUN apt install -y ssh
RUN apt install -y netplan.io

# resizerootfs
RUN apt install -y udev
RUN apt install -y parted

# ifconfig
RUN apt install -y net-tools

# needed by knod-static-nodes to create a list of static device nodes
RUN apt install -y kmod

# Install our resizerootfs service
COPY root/etc/systemd/ /etc/systemd

RUN systemctl enable resizerootfs
RUN systemctl enable ssh
RUN systemctl enable systemd-networkd
RUN systemctl enable setup-resolve

RUN mkdir -p /opt/nvidia/l4t-packages
RUN touch /opt/nvidia/l4t-packages/.nv-l4t-disable-boot-fw-update-in-preinstall

COPY root/etc/apt/ /etc/apt
COPY root/usr/share/keyrings /usr/share/keyrings
RUN apt update

# nv-l4t-usb-device-mode
RUN apt install -y bridge-utils

# https://docs.nvidia.com/jetson/l4t/index.html#page/Tegra%20Linux%20Driver%20Package%20Development%20Guide/updating_jetson_and_host.html
RUN apt install -y -o Dpkg::Options::="--force-overwrite" \
    nvidia-l4t-core \
    nvidia-l4t-init \
    nvidia-l4t-bootloader \
    nvidia-l4t-camera \
    nvidia-l4t-initrd \
    nvidia-l4t-xusb-firmware \
    nvidia-l4t-kernel \
    nvidia-l4t-kernel-dtbs \
    nvidia-l4t-kernel-headers \
    nvidia-l4t-cuda \
    jetson-gpio-common \
    python3-jetson-gpio

RUN rm -rf /opt/nvidia/l4t-packages

COPY root/ /

RUN useradd -ms /bin/bash jetson
RUN echo 'jetson:jetson' | chpasswd

RUN usermod -a -G sudo jetson

RUN apt-get update && apt-get install -y wget git nano cmake tar build-essential unzip pkg-config curl g++ python3-dev autotools-dev libicu-dev libbz2-dev libapr1 libapr1-dev libaprutil1-dev automake bash-completion build-essential btrfs-progs dnsutils htop iotop isc-dhcp-client iputils-ping kmod linux-firmware locales net-tools netplan.io pciutils ssh udev sudo unzip usbutils wpasupplicant network-manager python3-pip

RUN apt-get update && apt-get install -y libopencv-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-good1.0-dev libboost-all-dev libeigen3-dev libceres-dev libpoco-dev libtinyxml2-dev liblz4-dev libssl-dev

RUN mkdir -p /openvins_ws/src && cd /openvins_ws && mkdir dependencies && cd dependencies
WORKDIR /openvins_ws/dependencies
#RUN wget https://gitlab.com/libeigen/eigen/-/archive/3.3.4/eigen-3.3.4.tar.gz && tar -xvf eigen-3.3.4.tar.gz && cd eigen-3.3.4 && mkdir build && cd build && cmake .. && make -j8 && make install 

#RUN git clone --branch 3.4.18 https://github.com/opencv/opencv.git && cd opencv && mkdir build && cd build && cmake .. && make -j8  && make install

#RUN wget https://boostorg.jfrog.io/artifactory/main/release/1.81.0/source/boost_1_81_0.tar.gz && tar -xvf boost_1_81_0.tar.gz && cd boost_1_81_0 && ./bootstrap.sh && ./b2 -j8 install

RUN git clone https://github.com/ros/console_bridge.git && cd console_bridge && mkdir build && cd build && cmake .. && make -j8  && make install

RUN git clone --branch v0.5.0 https://github.com/google/glog.git && cd glog && mkdir build && cd build && cmake .. && make -j8  && make install

#RUN git clone --branch 2.0.0 https://github.com/ceres-solver/ceres-solver.git && cd ceres-solver && mkdir build && cd build && cmake .. && make -j8  && make install

#RUN wget https://pocoproject.org/releases/poco-1.8.0.1/poco-1.8.0.1.tar.gz && tar -xvf poco-1.8.0.1.tar.gz && cd poco-1.8.0.1 && make -j8 && make install

#RUN git clone --branch 8.0.0 https://github.com/leethomason/tinyxml2.git && cd tinyxml2 && mkdir build && cd build && cmake .. && make -j8  && make install

#RUN git clone https://github.com/lz4/lz4 && cd lz4 && make -j8 && make install

RUN git clone https://github.com/google/googletest.git -b release-1.12.1 && cd googletest && mkdir build && cd build && cmake .. && make -j8  && make install


RUN git clone https://github.com/enthought/bzip2-1.0.6.git && cd bzip2-1.0.6 && make -j8  && make install


RUN wget https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.46.tar.bz2 && tar -xvf libgpg-error-1.46.tar.bz2 && cd libgpg-error-1.46 && ./configure && make -j8  && make install



RUN wget https://www.gnupg.org/ftp/gcrypt/libassuan/libassuan-2.5.5.tar.bz2 && tar -xvf libassuan-2.5.5.tar.bz2 && cd libassuan-2.5.5 && ./configure && make -j8  && make install


RUN wget https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.14.0.tar.bz2 && tar -xvf gpgme-1.14.0.tar.bz2 && cd gpgme-1.14.0 && ./configure && make -j8  && make install


RUN wget https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.10.1.tar.bz2 && tar -xvf libgcrypt-1.10.1.tar.bz2  && cd libgcrypt-1.10.1 && ./configure && make -j8  && make install


#RUN git clone https://github.com/openssl/openssl.git && cd openssl && ./Configure && make -j8 && make install

RUN wget https://archive.apache.org/dist/logging/log4cxx/0.11.0/apache-log4cxx-0.11.0.zip && unzip apache-log4cxx-0.11.0.zip && cd apache-log4cxx-0.11.0 && mkdir build && cd build && cmake .. && make -j8  && make install



RUN wget https://sourceforge.net/projects/geographiclib/files/distrib-C++/GeographicLib-2.1.2.tar.gz && tar -xvf GeographicLib-2.1.2.tar.gz && cd GeographicLib-2.1.2 && mkdir build && cd build && cmake .. && make -j8 && make install


RUN wget https://github.com/jbeder/yaml-cpp/archive/refs/tags/yaml-cpp-0.7.0.tar.gz && tar -xvf yaml-cpp-0.7.0.tar.gz && cd yaml-cpp-yaml-cpp-0.7.0 && mkdir build && cd build && cmake -DYAML_BUILD_SHARED_LIBS=on .. && make -j8 && make install

#RUN wget https://gitlab.freedesktop.org/gstreamer/gstreamer/-/archive/1.14/gstreamer-1.14.tar.gz && tar -xvf gstreamer-1.14.tar.gz && cd gstreamer-1.14 && mkdir build && meson build && cd build && ninja && ninja install 

#RUN wget https://gitlab.freedesktop.org/gstreamer/gst-plugins-base/-/archive/1.14/gst-plugins-base-1.14.tar.gz && tar -xvf gst-plugins-base-1.14.tar.gz && cd gst-plugins-base-1.14 && mkdir build && meson build && cd build && ninja && ninja install 

#RUN wget https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/-/archive/1.14/gst-plugins-good-1.14.tar.gz && tar -xvf gst-plugins-good-1.14.tar.gz && cd gst-plugins-good-1.14 && mkdir build && meson build && cd build && ninja && ninja install 


WORKDIR /openvins_ws

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
RUN apt update && apt-get install python3-dev python3-rosdep python3-rosinstall-generator python3-catkin-tools -y
RUN pip3 install vcstool empy numpy defusedxml future 
RUN rosdep init && rosdep update
RUN rosinstall_generator ros_comm common_msgs sensor_msgs image_transport vision_opencv tf mavlink mavros nodelet image_common --rosdistro noetic --deps --wet-only --tar > ros-noetic-wet.rosinstall
RUN vcs import --input ros-noetic-wet.rosinstall ./src
RUN rosdep install --from-paths ./src --ignore-packages-from-source --rosdistro noetic -y

WORKDIR /openvins_ws/src

RUN git clone https://github.com/orocos/orocos_kinematics_dynamics.git

RUN git clone https://github.com/rpng/open_vins.git

RUN git clone https://github.com/ioarun/gscam.git

WORKDIR /openvins_ws

ENV ROS_PYTHON_VERSION=3

RUN ./src/mavros/mavros/scripts/install_geographiclib_datasets.sh

RUN catkin build gscam

RUN apt update && apt-get install -y ros-noetic-ros-base

#RUN catkin config --merge-devel --merge-install --install

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/aarch64-linux-gnu/tegra

RUN catkin build ov_core

#RUN catkin build ov_init

#RUN catkin build ov_msckf

#RUN catkin clean --yes

