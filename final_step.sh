#!/usr/bin/env bash

mkdir -p ~/simulation && cd ~/simulation && git clone https://github.com/erlerobot/ardupilot -b gazebo

mkdir -p ~/simulation/ros_catkin_ws/src && cd ~/simulation/ros_catkin_ws/src
. /opt/ros/indigo/setup.bash; catkin_init_workspace ~/simulation/ros_catkin_ws/src
cd ~/simulation/ros_catkin_ws
. /opt/ros/indigo/setup.bash; cd ~/simulation/ros_catkin_ws; catkin_make
echo "source ~/simulation/ros_catkin_ws/devel/setup.bash" >> ~/.bashrc
source ~/.bashrc

cd ~/simulation/ros_catkin_ws/src && \
git clone https://github.com/erlerobot/ardupilot_sitl_gazebo_plugin && \
git clone https://github.com/tu-darmstadt-ros-pkg/hector_gazebo/ && \
git clone https://github.com/erlerobot/rotors_simulator -b sonar_plugin && \
git clone https://github.com/PX4/mav_comm.git && \
git clone https://github.com/ethz-asl/glog_catkin.git && \
cp glog_catkin/fix-unused-typedef-warning.patch . && \
git clone https://github.com/catkin/catkin_simple.git && \
git clone https://github.com/erlerobot/mavros.git && \
git clone https://github.com/ros-simulation/gazebo_ros_pkgs.git -b indigo-devel && \
git clone https://github.com/erlerobot/gazebo_cpp_examples && \
git clone https://github.com/erlerobot/gazebo_python_examples

mkdir -p ~/.gazebo/models
git clone https://github.com/erlerobot/erle_gazebo_models
mv erle_gazebo_models/* ~/.gazebo/models
sudo rm -r erle_gazebo_models

cd ~/simulation/ros_catkin_ws
catkin_make --pkg mav_msgs mavros_msgs gazebo_msgs
source devel/setup.bash
catkin_make -j 4
