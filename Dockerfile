FROM ros:noetic-perception
RUN apt-get update && \
    apt-get install -y git cmake libgoogle-glog-dev libgflags-dev libatlas-base-dev libeigen3-dev libsuitesparse-dev wget
RUN wget http://ceres-solver.org/ceres-solver-2.1.0.tar.gz && \
    tar zxf ceres-solver-2.1.0.tar.gz && \
    mkdir ceres-bin && \
    cd ceres-bin && \
    cmake ../ceres-solver-2.1.0 && \
    make -j2 && \
    make test && \
    make install 
RUN apt-get install -y libboost-all-dev python3-catkin-tools
RUN apt-get install -y ros-noetic-geodesy ros-noetic-pcl-ros ros-noetic-nmea-msgs ros-noetic-libg2o
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    rm -rf /var/lib/apt/lists/*
RUN add-apt-repository ppa:borglab/gtsam-release-4.0 -y
RUN apt-get update && \
    apt-get install -y libgtsam-dev libgtsam-unstable-dev
#RUN git clone https://github.com/koide3/ndt_omp.git /catkin_ws/src/ndt_omp
#RUN git clone https://github.com/SMRT-AIST/fast_gicp.git --recursive /catkin_ws/src/fast_gicp

COPY hdl_graph_slam /catkin_ws/src/hdl_graph_slam
COPY fast_gicp /catkin_ws/src/fast_gicp
COPY ndt_omp /catkin_ws/src/ndt_omp

RUN cd /catkin_ws && \
    . /opt/ros/${ROS_DISTRO}/setup.sh && \
    rosdep update && \
    rosdep install -r --from-paths src --ignore-src --rosdistro=${ROS_DISTRO} -y && \
    catkin config --install && \
    catkin_make -j1
