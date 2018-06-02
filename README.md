# ros-indigo-erle-docker

This repo contains the necessary Dockerfile and execution scripts to compile and
run a Docker container for a full Ubuntu 14.04, ROS Indigo, Gazebo 7 and 
dependencies to simulate Erle Robotics' Erle-Copter. 

The compiled Docker image can be found [here](https://hub.docker.com/r/helmifraser/indigo-trusty-erle/). I recommend simply using this image instead of compiling from scratch. Remember to ``docker commit`` after a session, else no changes will be saved.

Username: indigo
Password: password

*Note: this has only been tested under Ubuntu 16.04. Your mileage may vary.*

## Using the precompiled image

1. Install [Docker](https://docs.docker.com/install/) and follow the [post-installation steps](https://docs.docker.com/install/linux/linux-postinstall/)
2. Pull the image from the [hub](https://hub.docker.com/r/helmifraser/indigo-trusty-erle/) using:
					``docker pull docker pull helmifraser/indigo-trusty-erle``
3. Run the container:
					``./run.sh helmifraser/indigo-trusty-erle``

You should now be in the home directory. Check if everything's running by [launching the simulation](http://docs.erlerobotics.com/simulation/vehicles/erle_copter/tutorial_1). You can use ``tmux`` with my configurations to make life a little easier, see the shortcuts in ``~/.tmux.conf``.

## Compiling the image

If for some reason you want to compile the image from  scratch, use the helper scripts.

1. Execute the build script, where IMAGE_NAME is the intended name of the image. Optionally, you can specify a USERNAME, which will be the username within the container.
					``./build.sh IMAGE_NAME USERNAME``
2. Once it's complete, execute the run script:
					``./run.sh IMAGE_NAME``
3. **Inside** the container, execute ``final_step.sh``, which will pull the necessary Git repos and compile them all. *This only needs to be done once.*
4.  Check if everything's running by [launching the simulation](http://docs.erlerobotics.com/simulation/vehicles/erle_copter/tutorial_1). 


