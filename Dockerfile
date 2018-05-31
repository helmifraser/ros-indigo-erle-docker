# Hoooo boy, okay, this dockerfile should setup everything for an erlecopter
# simulation environment.
# It containerizes an entire ubuntu 14.04 installation + ROS dependencies, all
# that is needed is to compile the catkin ws like so (there might be issues):

# catkin_make --pkg mav_msgs mavros_msgs gazebo_msgs
# source devel/setup.bash
# catkin_make -j 4

# user: indigo
# password: password

FROM osrf/ros:indigo-desktop-trusty

RUN useradd -ms /bin/bash indigo -p M6bzwuMFu29ok
RUN usermod -aG sudo indigo

RUN apt-get update
RUN apt-get install -y ros-indigo-desktop-full=1.1.6-0*
RUN apt-get install gawk make git curl cmake autoconf wget tar nano -y
RUN apt-get install g++ python-pip python-matplotlib \
                    python-serial python-wxgtk2.8 python-scipy \
                    python-opencv python-numpy python-pyparsing \
                    ccache realpath libopencv-dev -y

RUN pip install     future
RUN apt-get install libxml2-dev libxslt1-dev -y
RUN pip2 install    pymavlink catkin_pkg --upgrade
RUN pip install     MAVProxy==1.5.2

RUN cd /tmp && wget --content-disposition "https://downloads.sourceforge.net/project/aruco/OldVersions/aruco-1.3.0.tgz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Faruco%2Ffiles%2FOldVersions%2Faruco-1.3.0.tgz%2Fdownload&ts=1527786171"
RUN tar -xvzf aruco-1.3.0.tgz
RUN cd aruco-1.3.0/
RUN mkdir build && cd build
RUN cmake ..
RUN make
RUN make install

RUN apt-get install python-rosinstall          \
                    ros-indigo-octomap-msgs    \
                    ros-indigo-joy             \
                    ros-indigo-geodesy         \
                    ros-indigo-octomap-ros     \
                    ros-indigo-mavlink         \
                    ros-indigo-control-toolbox \
                    ros-indigo-transmission-interface \
                    ros-indigo-joint-limits-interface \
                    unzip -y


RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
RUN wget "http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -"
RUN apt-get update
RUN apt-get remove .*gazebo.* '.*sdformat.*' '.*ignition-math.*' && apt-get update && sudo apt-get install gazebo7 libgazebo7-dev drcsim7 -y

USER indigo
WORKDIR /home/indigo

RUN echo "source /opt/ros/indigo/setup.bash" >> ~/.bashrc
RUN source ~/.bashrc

RUN mkdir -p ~/simulation && cd ~/simulation
RUN git clone https://github.com/erlerobot/ardupilot -b gazebo

RUN mkdir -p ~/simulation/ros_catkin_ws/src && cd ~/simulation/ros_catkin_ws/src
RUN catkin_init_workspace
RUN cd ~/simulation/ros_catkin_ws
RUN catkin_make
RUN echo "source devel/setup.bash" > ~/.bashrc
RUN source ~/.bashrc

RUN cd ~/simulation/ros_catkin_ws/src
RUN git clone https://github.com/erlerobot/ardupilot_sitl_gazebo_plugin
RUN git clone https://github.com/tu-darmstadt-ros-pkg/hector_gazebo/
RUN git clone https://github.com/erlerobot/rotors_simulator -b sonar_plugin
RUN git clone https://github.com/PX4/mav_comm.git
RUN git clone https://github.com/ethz-asl/glog_catkin.git
RUN cp glog_catkin/fix-unused-typedef-warning.patch .
RUN git clone https://github.com/catkin/catkin_simple.git
RUN git clone https://github.com/erlerobot/mavros.git
RUN git clone https://github.com/ros-simulation/gazebo_ros_pkgs.git -b indigo-devel
RUN git clone https://github.com/erlerobot/gazebo_cpp_examples
RUN git clone https://github.com/erlerobot/gazebo_python_examples

RUN mkdir -p ~/.gazebo/models
RUN git clone https://github.com/erlerobot/erle_gazebo_models
RUN mv erle_gazebo_models/* ~/.gazebo/models
RUN rm -r erle_gazebo_models
