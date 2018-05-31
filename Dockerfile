FROM ros:indigo

# Arguments
ARG user
ARG uid
ARG home
ARG workspace
ARG shell

# Basic Utilities
RUN apt-get -y update && apt-get install -y zsh screen tree sudo ssh synaptic wget tar nano gedit 

# Erle dependencies
RUN apt-get install gawk make git curl cmake autoconf -y
RUN apt-get install g++ python-pip python-matplotlib \
                    python-serial python-wxgtk2.8 python-scipy \
                    python-opencv python-numpy python-pyparsing \
                    ccache realpath libopencv-dev -y

RUN pip install     future
RUN apt-get install libxml2-dev libxslt1-dev -y
RUN pip2 install    pymavlink catkin_pkg --upgrade
RUN pip install     MAVProxy==1.5.2

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

RUN cd /tmp && wget --content-disposition "https://downloads.sourceforge.net/project/aruco/OldVersions/aruco-1.3.0.tgz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Faruco%2Ffiles%2FOldVersions%2Faruco-1.3.0.tgz%2Fdownload&ts=1527786171" && tar -xvzf aruco-1.3.0.tgz && cd aruco-1.3.0/ && mkdir build && cd build && cmake .. && make && make install


# Latest X11 / mesa GL
RUN apt-get install -y\
  xserver-xorg-dev-lts-wily\
  libegl1-mesa-dev-lts-wily\
  libgl1-mesa-dev-lts-wily\
  libgbm-dev-lts-wily\
  mesa-common-dev-lts-wily\
  libgles2-mesa-lts-wily\
  libwayland-egl1-mesa-lts-wily\
  libopenvg1-mesa

# Dependencies required to build rviz
RUN apt-get install -y\
  qt4-dev-tools\
  libqt5core5a libqt5dbus5 libqt5gui5 libwayland-client0\
  libwayland-server0 libxcb-icccm4 libxcb-image0 libxcb-keysyms1\
  libxcb-render-util0 libxcb-util0 libxcb-xkb1 libxkbcommon-x11-0\
  libxkbcommon0

# The rest of ROS-desktop
RUN apt-get install -y ros-indigo-desktop-full

# Get Gazebo 7
RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
RUN wget http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -
RUN apt-get update
RUN apt-get remove .*gazebo.* '.*sdformat.*' '.*ignition-math.*' -y && apt-get update && apt-get install gazebo7 libgazebo7-dev drcsim7 -y

# Additional development tools
RUN apt-get install -y x11-apps python-pip build-essential
RUN pip install catkin_tools

# Make SSH available
EXPOSE 22

# Mount the user's home directory
VOLUME "${home}"

# Clone user into docker image and set up X11 sharing
RUN \
  echo "${user}:x:${uid}:${uid}:${user},,,:${home}:${shell}" >> /etc/passwd && \
  echo "${user}:x:${uid}:" >> /etc/group && \
  echo "${user} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${user}" && \
  chmod 0440 "/etc/sudoers.d/${user}"

# Switch to user
USER "${user}"

# This is required for sharing Xauthority
ENV QT_X11_NO_MITSHM=1
ENV CATKIN_TOPLEVEL_WS="${workspace}/devel"

# Switch to the workspace
WORKDIR ${workspace}
